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

  private

  def started_at_before_ended_at
    errors.add(:ended_at, "fin no puede ser previo a inicio") if (ended_at.present? && started_at > ended_at)
  end

  def opened_at_before_opened_at
    errors.add(:open_at, "cerrado no puede ser previo a abierto") if (closed__at.present? && opened_at > closed_at)
  end

end
