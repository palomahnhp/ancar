class Metric < ActiveRecord::Base
  has_many :indicator_metrics
  belongs_to :item, -> { where item_type: 'metric' }
end
