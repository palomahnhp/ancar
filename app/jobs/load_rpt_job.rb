class LoadRptJob < ActiveJob::Base
  queue_as :rpts

  def perform(year, file)
    require 'rake'
    Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
    Ancar::Application.load_tasks
    ENV['year'] = year
    ENV['file'] = "public/carga_rpt/#{file}"
    Rake::Task['rpts:carga'].reenable
    Rake::Task['rpts:carga'].invoke
  end
end
