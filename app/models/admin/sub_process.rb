class Admin::SubProcess < ActiveRecord::Base
  belongs_to :process
  has_many :tasks
end
