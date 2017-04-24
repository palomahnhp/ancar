class Source < ActiveRecord::Base
  has_many :indicator_sources
  belongs_to :item, -> { where item_type: 'source' }
end
