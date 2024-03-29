class FetchWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_and_while_executing, lock_expiration: 120 * 60

  LIMIT = 1500 # rate limit for making request to get user timeline (tweets)
  # A worker for fetching tweets from Twitter
  # and put it in database.

  def perform

    # Get all twitter accounts if any
    accounts = TwitterAccount.exists? ? TwitterAccount.least_checked(LIMIT) : []

    accounts.each do |account|
      account_name = account.twitter_name

      if Event.exists?(username: account_name)
        recent_tweet_id = Event.maximum('tweet_id')
        options = {
          since_id: recent_tweet_id
        }
      else
        options = {
          count: 20
        }
      end

      fetch_job(account_name, options)
      update_account(account.id)
    end

  end

  private

  # Map tweet values and save it to the database
  def save_tweet(tweet, user)
    RawTweet.create(tweet_id: tweet.id) do |t|
      t.full_text       = tweet.full_text
      t.uri             = tweet.uri
      t.tweet_posted_at = tweet.created_at
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

  # Update last_fetched column in twitter_accounts table
  def update_account(id)
    TwitterAccount.update(id, last_checked: Time.now)
  end
end
