class SubProcess < ActiveRecord::Base
  belongs_to :process
  has_many :tasks
end
