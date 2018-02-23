namespace :background_worker do

  require 'sidekiq/api'

  desc "Run fetch worker asynchronously"
  task fetch_tweets: :environment do

    condition = true
    while condition
      # FetchWorker.perform_async

      stats = Sidekiq::Stats.new
      count = stats.enqueued
      count < 100 ? FetchWorker.perform_async : ""
    end
  end

end
