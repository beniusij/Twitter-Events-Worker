namespace :background_worker do

  require 'sidekiq/api'

  desc "Run fetch worker asynchronously"
  task fetch_tweets: :environment do

    condition = true
    while condition
      # Create a statistics object for queues
      # After each iteration, the object will be created again
      # since it does not update dynamically
      stats = Sidekiq::Stats.new
      count = stats.enqueued

      # My way of capping the size of a queue
      count < 100 ? FetchWorker.perform_async : ""
    end
  end

  desc "Run fetch worker asynchronously"
  task check_tweets: :environment do

    condition = true
    while condition
      # Create a statistics object for queues
      # After each iteration, the object will be created again
      # since it does not update dynamically
      stats = Sidekiq::Stats.new
      count = stats.enqueued

      # My way of capping the size of a queue
      count < 100 ? CheckWorker.perform_async : ""
    end
  end

end
