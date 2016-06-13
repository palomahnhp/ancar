class IndicatorGroup < ActiveRecord::Base
  belongs_to :indicator_metric
  has_many :total_indicators
end
