class ImportRptJob < ActiveJob::Base
  queue_as :imports

  def perform(year, file)
    puts 'Start rpt import' + Time.zone.now.to_s
    sleep 5
    puts 'End   rpt import' + Time.zone.now.to_s
  end
end
