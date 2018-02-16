class LoadRptJob < ActiveJob::Base
  queue_as :rpt

  def perform(year, organization)
    require 'rake'
    Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
    Ancar::Application.load_tasks
    ENV['year'] = year
    ENV['organization_id'] = organization
    ENV['file'] = "public/carga_rpt/organization_#{organization}.xlsx"
    Rake::Task['rpt:carga'].reenable
    Rake::Task['rpt:carga'].invoke
  end
end
