class IndicatorMetric < ActiveRecord::Base
  belongs_to :indicator
  belongs_to :metric
#  has_many :entry_indicators
  has_many :entry_indicators, :dependent => :destroy
  has_many :total_indicators, :dependent => :destroy

   def copy(i_id)
     IndicatorMetric.create(self.attributes.merge(id: nil, indicator_id: i_id))
  end
end

