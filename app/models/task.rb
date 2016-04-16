class Task < ActiveRecord::Base
  has_many :indicators
  belongs_to :sub_process
end
