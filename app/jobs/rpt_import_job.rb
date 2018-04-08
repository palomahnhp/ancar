class RptImportJob < ActiveJob::Base
  queue_as :imports

  def perform(year, extname, filepath)
    RptImporter.new(year, extname, filepath).run
  end
end
