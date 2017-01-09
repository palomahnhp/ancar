class IndicatorMetric < ActiveRecord::Base
  belongs_to :indicator
  belongs_to :metric

  has_many :indicator_sources, :dependent => :destroy

  has_many :entry_indicators, :dependent => :destroy
  has_many :total_indicators, :dependent => :destroy

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

end

