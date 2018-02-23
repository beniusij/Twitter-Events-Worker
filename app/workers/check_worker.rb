class CheckWorker
  include Sidekiq::Worker

  # Worker will check whether the tweet is valid
  # by checking if it has words that could be parsed
  # to a date.
  def perform()
    # Get a list of tweets that have not been checked and are not valid
    options = {
        is_checked: false,
    }
    raw_tweets = RawTweet
    # Loop throught the list of tweets
      # Split the full_text into an array of words full_text.split
      # Iterate through the array
        # Strip any non-word characters     word.gsub!(/[^0-9A-Za-z]/, '')
        # is_valid = Chronic.parse(w).class == Time
        # if is_valid
          # Update in db is_valid column by setting it to TRUE
  end
end
