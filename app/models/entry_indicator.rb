class EntryIndicator < ActiveRecord::Base
  has_many :entry_indicator_sources

  has_many :metrics, through: :indicator_metrics
  has_many :indicators, through: :indicator_metrics
  has_many :sources, through: :entry_indicator_sources

  belongs_to :indicator_metric
  belongs_to :unit, inverse_of: :entry_indicators
  validates_presence_of :unit

  scope :period, ->(id) { where(period_id: id) }

end
