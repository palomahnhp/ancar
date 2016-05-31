class EntryIndicator < ActiveRecord::Base
  belongs_to :indicator
  belongs_to :unit
  belongs_to :task
  has_many :indicator_sources
  has_many :sources, through: :indicator_sources
end
