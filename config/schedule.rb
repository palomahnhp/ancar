# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
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
# Update whenever -w  o whenever --update-crontab
#

set :output, {:error => "log/cron_ancar_error.log", :standard => "log/cron_ancar_log.log"}

every 1.minute do
  command "date > log/cron_ancar_test_log.log"
end


