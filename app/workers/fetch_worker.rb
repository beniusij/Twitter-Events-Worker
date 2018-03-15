class FetchWorker
  include Sidekiq::Worker

  # A worker for fetching tweets from Twitter
  # and put it in database.

  def perform

    # Get all twitter accounts if any
    TwitterAccount.exists? ? accounts = TwitterAccount.all : accounts = []

    accounts.each do |account|
      account_name = account.twitter_name

      if RawTweet.exists?(username: account_name)
        recent_tweet_id = RawTweet.maximum('tweet_id')
        options = {
            since_id: recent_tweet_id
        }
      else
        options = {
            count: 20
        }
      end

      fetch_job(account_name, options)
    end

  end

  private

  # Map tweet values and save it to the database
  def save_tweet(tweet, user)
    RawTweet.create(tweet_id: tweet.id) do |t|
      t.full_text       = tweet.full_text
      t.uri             = tweet.uri
      t.tweet_posted_at = tweet.created_at
      t.user_location   = user.location
      t.username        = user.screen_name
      t.place           = place(tweet)
    end
  end

  # Fetch tweets from the platform
  def fetch_job(acc, options)
    tweets = $client.user_timeline(acc, options)
    user = $client.user(acc)

    # FOR EACH tweet IN tweets DO
    tweets.each do |tweet|
      # Store the tweet in PostgreSQL  database
      save_tweet(tweet, user)
    end

      # Catch exception
  rescue Twitter::Error::TooManyRequests => error
    sleep error.rate_limit.reset_in + 1
    retry
  end

  # Get event place
  def place(tweet)
    if tweet.place?
      tweet.place.full_name
    else
      tweet.user.location
    end
  end
end
