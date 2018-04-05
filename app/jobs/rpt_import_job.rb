class RptImportJob < ActiveJob::Base
  queue_as :imports

  def perform(year, extname, filepath)
    puts 'Start rpt import' + Time.zone.now.to_s
    RptImporter.new(year, extname, filepath).run
    puts 'End   rpt import' + Time.zone.now.to_s
  end
end
