class RptImportJob < ActiveJob::Base
  queue_as :imports

  def perform(year, extname, filepath)
    Importers::RptImporter.new(year, extname, filepath).run
  end
end