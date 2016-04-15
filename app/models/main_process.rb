class MainProcess < ActiveRecord::Base
	has_many :sub_process
	belongs_to :period
end
