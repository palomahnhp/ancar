class IndicatorMetric < ActiveRecord::Base
  belongs_to :indicator
  belongs_to :metric
#  has_many :entry_indicators
  has_many :entry_indicators, :dependent => :destroy
  has_many :total_indicators, :dependent => :destroy

  def copy(indicator_id)
     indicator_metric = IndicatorMetric.create(self.attributes.merge(id: nil, indicator_id: indicator_id))
     self.total_indicators.each do |total_indicator|
       total_indicator.copy(indicator_metric.id)
     end
  end
end

