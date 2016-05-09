class Period < ActiveRecord::Base
  has_many :main_process
  belongs_to :organization_type

  validates :description, presence: true
  validates :opened_at, presence: true
  validates :closed_at, presence: true
  validates :started_at, presence: true
  validates :ended_at, presence: true

  def is_open?
    opened_at <=  DateTime.now  && closed_at >=  DateTime.now
  end
end
