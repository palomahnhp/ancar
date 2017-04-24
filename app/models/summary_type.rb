class SummaryType < ActiveRecord::Base
  belongs_to :item, -> { where item_type: 'summary_type' }
  has_many :total_indicators

  default_scope { where(active: true) }
  scope :process, -> { where(acronym: 'P') }
  scope :sub_process, -> { where(acronym: 'S') }
  scope :stock, -> { where(acronym: 'U') }

  def self.find_id(id)
    self.find(id)
  end

end
