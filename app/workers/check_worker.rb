class CheckWorker
  include Sidekiq::Worker
  require 'chronic'

  # Worker will check whether the tweet is valid
  # by checking if it has words that could be parsed
  # to a date.
  def perform()
    # Get a list of tweets that have not been checked
    options = {
        is_checked: false
    }
    # Loop throught the list of tweets
    RawTweet.where(options).each do |tweet|
      is_valid = false
      # Split the full_text into an array of words full_text.split
      text = tweet.full_text.split
      # Iterate through the array
      text.each do |word|
        unless is_valid
          # Strip any non-word characters
          word = word.gsub!(/[^0-9A-Za-z]/, '')
          is_valid = Chronic.parse(word).class == Time
        end
      end
      # Update record, since it has been checked
      update(tweet, is_valid)
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

end
