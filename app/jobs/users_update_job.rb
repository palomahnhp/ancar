class UsersUpdateJob < ActiveJob::Base
  queue_as :users

  def perform
    UsersUpdate.new.run
  end
end