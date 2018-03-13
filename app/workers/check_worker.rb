class CheckWorker
  include Sidekiq::Worker
  require 'chronic'

  # Worker will check whether the tweet is valid
  # by checking if it has words that could be parsed
  # to a date.
  def perform
    # Get a list of tweets that have not been checked
    options = {
      is_checked: false
    }
    # Loop through the list of tweets
    RawTweet.where(options).each do |tweet|
      # Update record, since it has been checked
      update(tweet, valid?(tweet.full_text))
    end
  end

  private

  # Update is_valid for an existing record
  def update(tweet, is_valid)
    properties = {
      is_valid: is_valid,
      is_checked: true
    }
    RawTweet.update(tweet.id, properties)
  end

  # Evaluate if the message contains verbal date
  def valid?(text)
    is_valid = false
    # Split the full_text into an array of words full_text.split
    text = text.split
    # Iterate through the array
    text.each do |word|
      unless is_valid
        is_valid = check_wo_regex(word)
        unless is_valid
          is_valid = check_w_regex(word)
        end
      end
    end
    is_valid
  end

  # Attempt to convert string to date w/o stripping of any characters
  def check_wo_regex(word)
    Chronic.parse(word).class == Time
  end

  # Attempt to convert string to date after striping of any special symbols
  def check_w_regex(word)
    # Strip any non-word characters
    word = word.gsub(/[^0-9A-Za-z]/, '')
    Chronic.parse(word).class == Time
  end
end
