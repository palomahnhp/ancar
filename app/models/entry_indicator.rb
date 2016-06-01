class EntryIndicator < ActiveRecord::Base
  belongs_to :indicator_metrics
  belongs_to :unit

  has_many :entry_indicator_sources
  has_many :entry_indicator_metrics
  has_many :sources, through: :entry_indicator_sources
  has_many :metrics, through: :indicator_metrics
  has_many :indicators, through: :indicator_metrics
end
