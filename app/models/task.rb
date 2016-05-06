class Task < ActiveRecord::Base
  has_many :indicators
  belongs_to :sub_process
  belongs_to :item, -> { where item_type: "tasks" }

  validates :sub_process_id, presence: true
  validates :item_id, presence: true
end
