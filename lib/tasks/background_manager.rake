namespace :background_manager do
  require 'sidekiq/api'

  desc "Clean jobs in a queue"
  task clean_jobs: :environment do
    queue = Sidekiq::Queue.new("default")
    puts "Before cleaning default queue: " + queue.count.to_s
    queue.clear
    puts "Clean"
    puts "After cleaning default queue: " + queue.count.to_s

    rs = Sidekiq::RetrySet.new
    puts "Before cleaning retry set: " + rs.size.to_s
    rs.clear
    puts "Clean"
    puts "After cleaning retry queue: " + queue.count.to_s
  end

end
