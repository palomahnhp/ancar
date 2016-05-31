class Indicator < ActiveRecord::Base
  has_many :indicator_sources
  has_many :sources, through: :indicator_sources
  has_many :entry_indicator
  belongs_to :task
  belongs_to :metric
  belongs_to :item, -> { where item_type: "indicator" }
end
