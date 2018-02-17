class FetchWorker
  include Sidekiq::Worker

  # A worker for fetching tweets from Twitter
  # and put it in database.

  def perform()
    tweets = $client.user_timeline("TheAsylumVenue")
    puts tweets.size
  end
end
