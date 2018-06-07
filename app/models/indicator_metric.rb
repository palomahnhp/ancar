class IndicatorMetric < ActiveRecord::Base
  include Trackable

  belongs_to :indicator
  belongs_to :metric

  has_many :indicator_sources, inverse_of: :indicator_metric, :dependent => :destroy
  accepts_nested_attributes_for :indicator_sources, reject_if: :all_blank, allow_destroy: true

  has_many :entry_indicators, :dependent => :destroy
  has_many :total_indicators, :dependent => :destroy

  scope :in, -> { where(in_out_type: 'E') }
  scope :out, -> { where(in_out_type: 'S') }
  scope :stock, -> { where(in_out_type: 'X') }

  def copy(indicator_id)
     indicator_metric = IndicatorMetric.create(self.attributes.merge(id: nil, indicator_id: indicator_id))
     indicator_sources.each do |is|
       is.copy(indicator_metric.id)
     end

     self.total_indicators.each do |total_indicator|
       total_indicator.copy(indicator_metric.id)
     end
  end

  def self.metric_id(id)
    return 0 if id.nil?
    IndicatorMetric.find(id).metric.id
  end

  def sub_process
    indicator.task.sub_process
  end

  def main_process
    sub_process.main_process
  end

  def period
    main_process.period
  end

  def modifiable?
    period.modifiable?
  end

  def eliminable?
    period.eliminable?
  end

  def amount(unit_id)
    self.entry_indicators.where(unit_id: unit_id).sum(:amount)
  end

  def total_indicator_type(summary_type)
    summary_type = SummaryType.find_by_acronym(summary_type)
    ti = summary_type.total_indicators.find_by_indicator_metric_id(self.id)
    if ti.nil?
      summary_type = SummaryType.find_by_acronym('X')
      ti = summary_type.total_indicators.find_by_indicator_metric_id(self.id) unless summary_type.nil?
      type = ti.nil? ? '' : ti.indicator_type
    else
      type = ti.in_out
    end
      return type == '-' ? ' ' : type
  end

  def source_description
    return indicator_sources.first.source.item.description if indicator_sources.present?
    ' '
  end

  def source_fixed
    return indicator_sources.first.source.fixed if indicator_sources.present?
    false
  end

end

