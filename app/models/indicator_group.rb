class IndicatorGroup < ActiveRecord::Base
  has_many :total_indicators
	belongs_to :item, -> { where item_type: "indicator_group" }

  validates :item_id, presence: true
end
