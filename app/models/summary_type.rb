class SummaryType < ActiveRecord::Base
  belongs_to :item, -> { where item_type: "summary_type" }
  has_many :total_indicators

  scope :active, -> { where(active: true) }
#  scope :active -> lambda { where('active = ?', TRUE) }
end
