class FetchWorker
  include Sidekiq::Worker

  # A worker for fetching tweets from Twitter
  # and put it in database.

  def perform()

    # Fetch tweets from the platform
    tweets = $client.user_timeline("TheAsylumVenue", {count: 5})
    puts tweets.size

    # FOR EACH tweet IN tweets DO
    tweets.each do |tweet|
      save_tweet(tweet)
    end
    # Store the tweet in PostgreSQL  database
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
