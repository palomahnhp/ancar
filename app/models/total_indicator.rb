class TotalIndicator < ActiveRecord::Base
  belongs_to :indicator_metric
  belongs_to :indicator_group
end
