class InitializeValidationsJob < ActiveJob::Base
  queue_as :initializations

  def perform(period)
    require 'rake'
    Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
    Ancar::Application.load_tasks
    ENV['period'] = period
    Rake::Task['initialize:validations'].reenable
    Rake::Task['initialize:validations'].invoke
  end
end
