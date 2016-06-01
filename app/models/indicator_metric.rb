class IndicatorMetric < ActiveRecord::Base
  belongs_to :indicator
  belongs_to :metric
  belongs_to :entry_indicator
end

