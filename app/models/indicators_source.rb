class IndicatorsSource < ActiveRecord::Base
  belongs_to :indicator
  belongs_to :source
end

