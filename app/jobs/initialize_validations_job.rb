class InitializeValidationsJob < ActiveJob::Base
  queue_as :initializations
  after_perform :message

  def perform(period)
    require 'rake'
    Rake::Task.clear # necessary to avoid tasks being loaded several times in dev mode
    Ancar::Application.load_tasks
    ENV['period'] = period
    Rake::Task['initialize:validations'].reenable
    Rake::Task['initialize:validations'].invoke
  end

  def message
    p ' ** End initialize validations job'
  end
end
