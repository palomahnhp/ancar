class Indicator < ActiveRecord::Base
  has_many :indicator_sources
  has_many :indicator_metrics

  has_many :metrics, through: :indicator_metrics
  has_many :entry_indicators, through: :indicator_metrics
  has_many :sources, through: :indicator_sources

  belongs_to :task
  belongs_to :item, -> { where item_type: "indicator" }
end
