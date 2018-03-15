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
        place     = location(tweet)
        # From the tweet text get date and time
        date      = date(tweet.full_text)
        time      = time(tweet.full_text)
        # Keywords store as full_text for now
        keywords  = tweet.full_text
        username  = tweet.user.screen_name
        save_event(place, date, time, keywords, username)
        update_tweet(tweet.id)
      end
    end
  end

  private

  # Save the event in the table
  def save_event(place, date, time, keywords, username)
    Events.create do |t|
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

  # Get event date from text
  def date(text)
    # First attempt to extract date
    extract = Nickel.parse(text).occurrences[0]
    # Second attempt to extract date
    if extract.nil?
      clean_text = text.tr("\n", " ")
      clean_text = clean_text.gsub(/[^0-9A-Za-z. ]/, '')
      extract = Nickel.parse(clean_text).occurrences[0]
    end
    # Return parsed date or nil
    if extract.nil?
      extract
    else
      Nickel.parse(extract).occurrences[0].start_date.to_date
    end
  end

  # Get event [start] time from text
  def time(text)
    # First attempt to extract time
    extract = Nickel.parse(text).occurrences[0].start_time
    # Second attempt to extract time
    if extract.nil?
      clean_text = text.tr("\n", " ")
      clean_text = clean_text.gsub(/[^0-9A-Za-z. ]/, '')
      extract = Nickel.parse(clean_text).occurrences[0].start_time
    end
    # Return parsed time or nil
    if extract.nil?
      extract
    else
      Nickel.parse(extract).occurrences[0].start_time.to_time
    end
  end

end
