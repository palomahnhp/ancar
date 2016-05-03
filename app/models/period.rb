class Period < ActiveRecord::Base
  has_many :main_process
  belongs_to :organization_type
  has_many :sub_processes, through: :main_processes

  validates :organization_type_id, presence: true
  validates :description, presence: true
  validates :opened_at, presence: true
  validates :closed_at, presence: true
  validates :started_at, presence: true
  validates :ended_at, presence: true

  def is_open?
    opened_at <=  DateTime.now  && closed_at >=  DateTime.now
  end
end
