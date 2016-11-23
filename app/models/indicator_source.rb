class IndicatorSource < ActiveRecord::Base
  belongs_to :indicator
  belongs_to :source

#  has_many :entry_indicators

  has_many :entry_indicators, :dependent => :destroy

  def copy(i_id)
    IndicatorSource.create(self.attributes.merge(id: nil, indicator_id: i_id))
  end
end

