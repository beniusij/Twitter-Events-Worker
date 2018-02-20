class FetchWorker
  include Sidekiq::Worker

  # A worker for fetching tweets from Twitter
  # and put it in database.

  def perform()

    options = {count: 100}
    # Fetch tweets from the platform
    tweets = $client.user_timeline("TheAsylumVenue", options)

    # FOR EACH tweet IN tweets DO
    tweets.each do |tweet|
      # Store the tweet in PostgreSQL  database
      save_tweet(tweet)
    end

  # Catch exception
  rescue Twitter::Error::TooManyRequests => error
    sleep error.rate_limit.reset_in + 1
    retry
  end

  private

  # Map tweet values and save it to the database
  def save_tweet(tweet)
    RawTweet.create(tweet_id: tweet.id) do |t|
      t.full_text = tweet.full_text
      t.uri = tweet.uri
    end
  end

end
