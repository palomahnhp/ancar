class UnitAssignationJob < ActiveJob::Base
  queue_as :imports

  def perform(year, extname, filename, filepath)
    puts 'Start rpt import' + Time.zone.now.to_s
    UnitRptAssignationImporter.new(year, extname, filename, filepath).run
    puts 'End   rpt import' + Time.zone.now.to_s
  end
end
