namespace :background_worker do
  desc "Run fetch worker asynchronously"
  task fetch_tweets: :environment do
    condition = true
    while(condition)
      FetchWorker.perform_async
      sleep 1.minute
    end
  end

end
