# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# Use bundle exec whenever --update-crontab command update cron tab
# for a list of cron jobs to be executed.

set :output, './log/cron.log'

every 15.minutes do
  runner 'FetchWorker.perform_async'
end

every 3.minutes do
  runner 'ProcessWorker.perform_async'
end

every 1.hours do
  runner 'CleanWorker.perform_async'
end