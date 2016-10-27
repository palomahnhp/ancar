class SummaryType < ActiveRecord::Base
  belongs_to :item
  has_many :total_tndicators

end
