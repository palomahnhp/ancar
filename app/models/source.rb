class Source < ActiveRecord::Base
  has_many :indicator_sources
  belongs_to :item, -> { where item_type: 'source' }

  scope :not_fixed, -> { where("fixed = ? OR fixed = ?",  false, nil) }
  scope :fixed, -> { where(fixed: true) }

end
