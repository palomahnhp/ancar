class EntryIndicator < ActiveRecord::Base
  resourcify
  has_many :entry_indicator_sources

  has_many :metrics, through: :indicator_metrics
  has_many :indicators, through: :indicator_metrics
  has_many :sources, through: :entry_indicator_sources

  belongs_to :indicator_metric
  belongs_to :indicator_source
  belongs_to :unit, inverse_of: :entry_indicators

  validates_presence_of :unit

  validates_associated :indicator_metric
  validates_associated :indicator_source

  validates_numericality_of :amount


  scope :period, ->(id) { where(period_id: id) }

  def amount=(val)
    val.sub!(',', '.') if val.is_a?(String)
    self['amount'] = val
  end

  def self.delete_by_indicator_metric(unit_id, indicator_metric_id)
    self.where(unit_id: unit_id, indicator_metric_id: indicator_metric_id).delete_all
  end

  def fixed_sources
     self.indicator_sources.take.source.fixed?
  end

end
