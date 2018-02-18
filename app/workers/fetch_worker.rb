class FetchWorker
  include Sidekiq::Worker

  # A worker for fetching tweets from Twitter
  # and put it in database.

  def perform()

    # Fetch tweets from the platform
    tweets = $client.user_timeline("TheAsylumVenue")
    puts tweets.size

    # FOR EACH tweet IN tweets DO
    # Store the tweet in PostGIS database
  end
end
