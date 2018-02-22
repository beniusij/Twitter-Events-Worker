namespace :background_worker do

  require 'sidekiq/api'

  desc "Run fetch worker asynchronously"
  task fetch_tweets: :environment do
    queue = Sidekiq::Queue.new("default")
    count = queue.count
    condition = true
    while(condition)
      if count < 100
        FetchWorker.perform_async()
      end
    end
  end

end
