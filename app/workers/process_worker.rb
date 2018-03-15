class ProcessWorker
  include Sidekiq::Worker

  # A worker for processing valid tweets and creating events

  def perform
    options = {
      is_valid: true,
      is_processed: false
    }

    tweets = RawTweet.where(options)
    unless tweets.nil?
      tweets.each do |tweet|
        # Use tweet place if present, otherwise use user location
        place     = tweet.place
        # Clear the tweet text
        text = tweet.full_text.tr("\n", " ")
        text = text.gsub(/[^0-9A-Za-z. ]/, '')
        # From the tweet text get date and time
        date      = date(text)
        time      = time(text)
        # Keywords store as full_text for now
        keywords  = tweet.full_text
        username  = tweet.username
        save_event(place, date, time, keywords, username)
        update_tweet(tweet.id)
      end
    end
  end

  private

  # Save the event in the table
  def save_event(place, date, time, keywords, username)
    Event.create do |t|
      t.place     = place
      t.date      = date
      t.time      = time
      t.keywords  = keywords
      t.username  = username
    end
  end

  # Update the raw tweet as processed
  def update_tweet(id)
    RawTweet.update(id, is_processed: true)
  end

  def datetime?(text)
    # First attempt to get date or time
    datetime = Nickel.parse(text).occurrences[0]
    # Second attempt to get date or time w/ regex
    if datetime.nil?
      datetime = Nickel.parse(text).occurrences[0]
    end

    datetime.nil? ? false : true
  end

  # Get event date from text
  def date(text)
    datetime?(text) ? Nickel.parse(text).occurrences[0].start_date.to_date : ""
  end

  def time?(text)
    extract = Nickel.parse(text).occurrences[0].start_time
    extract.nil? ? false : true
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
