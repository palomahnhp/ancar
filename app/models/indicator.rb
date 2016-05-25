class Indicator < ActiveRecord::Base
  has_many :indicators_source
  has_many :sources, through: :indicators_source
  belongs_to :task
  belongs_to :metric
  belongs_to :item, -> { where item_type: "indicator" }
end
