class Source < ActiveRecord::Base
  has_many :indicator_sources
  belongs_to :item, -> { where item_type: 'source' }
  belongs_to :organization_type

  scope :not_fixed, -> { where("fixed = ? OR fixed = ?",  false, nil) }
  scope :fixed, -> { where(fixed: true) }

  def amount_uses
     IndicatorSource.where(source: self).count
  end
  def from_organization_type
    organization_type_id.present? ? self.organization_type.description : 'Todas'
  end
end
