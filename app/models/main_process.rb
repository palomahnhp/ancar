class MainProcess < ActiveRecord::Base
  has_many :sub_processes
  has_many :tasks, through: :sub_processes
  belongs_to :period
  belongs_to :item, -> { where item_type: "main_process" }

  validates :period_id, presence: true
  validates :item_id, presence: true
end
