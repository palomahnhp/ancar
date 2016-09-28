class Period < ActiveRecord::Base
  has_many :main_process
  belongs_to :organization_type

  validates :description, presence: true,  length: { in: 4..100 }
  validates :organization_type_id, presence: true
  validates :opened_at, presence: true
  validates :closed_at, presence: true
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validate :started_at_before_ended_at
  validate :opened_at_before_closed_at
  validate :ended_at_before_opened_at

  def open_entry?
    opened_at <=  DateTime.now  && closed_at >=  DateTime.now
  end

  def close_entry?
    closed_at <  DateTime.now
  end

  def modifiable?

  end

  def eliminable?
    (opened_at >  DateTime.now  && closed_at >=  DateTime.now) ||
    self.main_process.count == 0
  end

  private

  def started_at_before_ended_at
    errors.add(:ended_at, I18n.t("manager.periods.validate.period.ended_at")) if (started_at.present? &&  ended_at.present? && started_at > ended_at)
  end

  def opened_at_before_closed_at
    errors.add(:closed_at, I18n.t("manager.periods.validate.period.closed_at")) if (opened_at.present? && closed_at.present? && opened_at > closed_at)
  end

  def ended_at_before_opened_at
    errors.add(:ended_at, I18n.t("manager.periods.validate.period.opened_at")) if (ended_at.present? && opened_at.present? && ended_at > opened_at)
  end

  def copy(periodo_origen_id)
    main_process.each do |m|
      m.copy(periodo_origen_id)
    end
  end
end
