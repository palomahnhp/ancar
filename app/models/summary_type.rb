class SummaryType < ActiveRecord::Base
  belongs_to :item, -> { where item_type: "summary_type" }
  has_many :total_indicators

  default_scope { where(active: true) }

end
