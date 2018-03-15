class ProcessWorker
  include Sidekiq::Worker

  # A worker for processing valid tweets and creating events

  def perform
    options = {
        is_valid: true,
        is_processed: false
    }
    RawTweet.find_by(options).each do |tweet|
      # From the tweet text get date and time
      # Use tweet place if present, otherwise use user location
      # Keywords store as full_text for now
      date = date(tweet.full_text)
      time = time(tweet.full_text)
    end
  end

  private

  # Save the event in the table
  def save_event(place, date, time, keywords)
    Events.create do |t|
      t.place     = place
      t.date      = date
      t.time      = time
      t.keywords  = keywords
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
