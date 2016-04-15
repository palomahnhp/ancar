class SubProcess < ActiveRecord::Base
  has_many :tasks
  belongs_to :main_process
end
