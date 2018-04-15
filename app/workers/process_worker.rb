class ProcessWorker
  include Sidekiq::Worker

  sidekiq_options unique: :until_and_while_executing, lock_expiration: 10 * 60

  # A worker for processing valid tweets and creating events
  # 1. Check unprocessed tweet
  # 2. Valid tweets should be processed and events should be created
  # 3. Invalid tweets should be marked as processed and left for removal
  # by other worker
  def perform
    # Get unprocessed tweets
    options = { is_processed: false }
    tweets = RawTweet.where(options)
    unless tweets.nil?
      tweets.each do |tweet|
        if valid?(tweet.full_text)
          save_event(prep_event(tweet))
        end
        update_tweet(tweet.id)
      end
    end
  rescue NoMethodError => e
    puts e
  end

  private

  # Prepare event info for saving
  # Return hash array with info about event
  def prep_event(tweet)
    # From the tweet text get date and time
    date      = date(tweet.full_text)
    time      = time(tweet.full_text)
    {
        place:  tweet.place,
        date:   date,
        time:   time,
        keywords: tweet.full_text,
        username: tweet.username,
        id:       tweet.tweet_id
    }
  end

  # Remove new line symbols and extract only numbers and letters
  def clear_text(text)
    text = text.tr("\n", " ")
    text.gsub(/[^0-9A-Za-z. ]/, '')
  end

  # Save the event in the table
  def save_event(event)
    Event.create do |t|
      t.place     = event[:place]
      t.date      = event[:date]
      t.time      = event[:time]
      t.keywords  = event[:keywords]
      t.username  = event[:username]
      t.tweet_id  = event[:id]
    end
  end

  # Update the raw tweet as processed
  def update_tweet(id)
    RawTweet.update(id, is_processed: true)
  end

  # Checks if the tweet has valid date about event
  def valid?(text)
    datetime?(text) || datetime?(clear_text(text))
  end

  # Returns boolean for whether there is date in the text
  def datetime?(text)
    datetime = Nickel.parse(text).occurrences[0]
    datetime.nil? ? false : true

  rescue => e
    Failure.save_case(text, e)
    return false
  end

  # Returns boolean for whether there is time in text
  def time?(text)
    if datetime?(text)
      extract = Nickel.parse(text).occurrences[0].start_time
      extract.nil? ? false : true
    else
      false
    end

  rescue RuntimeError => e
    Failure.save_case(text, e)
    return false
  end

  # Get event date from text
  def date(text)
    if datetime?(text)
      Nickel.parse(text).occurrences[0].start_date.to_date
    else
      Nickel.parse(clear_text(text)).occurrences[0].start_date.to_date
    end
  end

  # Get event [start] time from text
  def time(text)
    if time?(text)
      Nickel.parse(text).occurrences[0].start_time.to_time
    else
      clean_text = clear_text(text)
      if time?(clean_text)
        Nickel.parse(clean_text).occurrences[0].start_time.to_time
      end
    end
  end

end
