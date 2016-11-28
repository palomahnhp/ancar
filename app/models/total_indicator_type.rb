class TotalIndicatorType < ActiveRecord::Base
  belongs_to :item, -> { where item_type: "total_indicator_type" }
  has_many :summary_types

  scope :active, -> { where(active: true) }
end
