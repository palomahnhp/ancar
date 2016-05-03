class Indicator < ActiveRecord::Base
  belongs_to :task
  belongs_to :item, -> { where item_type: "indicator" }
  has_many :indicator_sources

  validates :main_process_id, presence: true
  validates :item_id, presence: true
end
