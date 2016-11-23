class SummaryType < ActiveRecord::Base
  belongs_to :item
  has_many :total_tndicators

  scope :active, -> { where(active: true) }
#  scope :active -> lambda { where('active = ?', TRUE) }
end
