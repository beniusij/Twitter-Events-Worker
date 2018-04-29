desc "This task is called by the Heroku scheduler add-on"
task :fetch_tweets => :environment do
  puts "Fetching tweets..."
  FetchWorker.perform_async()
  puts "done."
end

task :process_tweets => :environment do
  puts "Processing tweets..."
  ProcessWorker.perform_async()
  puts "done."
end

task :cleanup => :environment do
  CleanWorker.perform_async()
end