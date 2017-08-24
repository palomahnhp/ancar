class TotalIndicatorType < ActiveRecord::Base
  belongs_to :item, -> { where item_type: 'total_indicator_type' }
  has_many :summary_types

  scope :active, -> { where(active: true) }

  def self.to_options
    @total_indicator_types ||= TotalIndicatorType.active.order(:order).includes(:item).map{ |type| [type.item.description, type.id] }
  end

  def self.acronym_id(in_out)
    self.find_by_acronym(in_out).id
  end
end
