class RptImportJob < ActiveJob::Base
  queue_as :imports

  def perform(year, extname, filename, filepath)
    RptImporter.new(year, extname, filename, filepath).run
  end
end
