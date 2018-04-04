class ImportRptJob < ActiveJob::Base
  queue_as :default

  def perform(year, extname, path)
    puts 'Start rpt import' + Time.zone.now.to_s
    Rpt.import(year, extname, path)
    puts 'End   rpt import' + Time.zone.now.to_s
  end
end
