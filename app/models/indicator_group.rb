class IndicatorGroup < ActiveRecord::Base
  belongs_to :indicator_metric
  has_many :total_indicators

  belongs_to :main_process
  belongs_to :unit_type
  belongs_to :item, -> { where item_type: "indicator_group" }

  validates :main_process_id, presence: true
  validates :item_id, presence: true
end
