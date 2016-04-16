class Admin::MainProcess < ActiveRecord::Base
  has_many  :sub_processes
  belongs_to :period
end
