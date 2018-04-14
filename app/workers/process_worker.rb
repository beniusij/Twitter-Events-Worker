class ProcessWorker
  include Sidekiq::Worker

  sidekiq_options unique: :until_and_while_executing, lock_expiration: 10 * 60

  # A worker for processing valid tweets and creating events

  def perform
    # Get unprocessed tweets
    options = {
      is_processed: false
    }
    # Check unprocessed tweet
    # Valid tweets should be processed and events should be created
    # Invalid tweets should be marked as processed and left for removal by other worker
    tweets = RawTweet.where(options)
    unless tweets.nil?
      tweets.each do |tweet|
        save_event(prep_event(tweet))
        update_tweet(tweet.id)
      end
    end
  rescue NoMethodError => e
    puts e
  end

  private

  # Checks if the tweet has valid info about event
  def is_valid?(tweet)
    is_valid = false

    unless is_valid
      is_valid = check_wo_regex(word)
      is_valid = check_w_regex(word) unless is_valid
    end

    is_valid
  end

  # Prepare event info for saving
  # Return hash array with info about event
  def prep_event(tweet)
    # Clear the tweet text
    text = clear_text(tweet.full_text)
    # From the tweet text get date and time
    date      = date(text)
    time      = time(text)

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
      t.place     = event.place
      t.date      = event.date
      t.time      = event.time
      t.keywords  = event.keywords
      t.username  = event.username
      t.tweet_id  = event.id
    end
  end

  # Update the raw tweet as processed
  def update_tweet(id)
    RawTweet.update(id, is_processed: true)
  end

  # Returns boolean for whether there is date in the text
  def datetime?(text)
    datetime = Nickel.parse(text).occurrences[0]
    datetime.nil? ? false : true

  rescue => e
    puts e
    return false
  end

  # Returns boolean for whether there is time in text
  def time?(text)
    extract = Nickel.parse(text).occurrences[0].start_time
    extract.nil? ? false : true
  rescue RuntimeError => e
    puts e
    return false
  end

  # Get event date from text
  def date(text)
    datetime?(text) ? Nickel.parse(text).occurrences[0].start_date.to_date : ""
  end

  # Get event [start] time from text
  def time(text)
    if datetime?(text)
      if time?(text)
        Nickel.parse(text).occurrences[0].start_time.to_time
      end
    end
  end

end
