class IndicatorSource < ActiveRecord::Base
  include ItemTrackable

  belongs_to :indicator_metric
  belongs_to :source

  has_many :entry_indicators, :dependent => :destroy
  validates :indicator_metric_id, presence: true
  validates :source_id, presence: true

  def copy(im_id)
    IndicatorSource.create(self.attributes.merge(id: nil, indicator_metric_id: im_id))
  end

  def self.source_id(id)
    return 0 if id.nil?
    self.find(id).source.id
  end
end

