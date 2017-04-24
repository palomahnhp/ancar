class Period < ActiveRecord::Base
  resourcify
  has_many :main_processes, :dependent => :destroy
  has_many :assigned_employees, :dependent => :destroy
  has_many :entry_indicators, :dependent => :destroy

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
    !close_entry?
  end

  def is_empty?
    self.main_processes.count == 0
  end

  def eliminable?
    modifiable? && is_empty? && !open_entry?
  end

  def copy(periodo_origen_id, current_user_login)
    p = Period.find(periodo_origen_id)
    p.main_processes.each do |mp|
      mp.copy(self.id, current_user_login)
    end

    p.assigned_employees.where(staff_of_type: 'Unit').each do |ae|
      ae.copy(self.id, current_user_login)
    end

  end

  def self.select_options
    self.all.order(:ended_at).collect { |v| [ v.description, v.id ] }
  end

  def self.look_up_description(description)
    self.find_by_description(description)
  end

  private

  def started_at_before_ended_at
    errors.add(:ended_at, I18n.t('supervisor.periods.validate.period.ended_at')) if (started_at.present? &&  ended_at.present? && started_at > ended_at)
  end

  def opened_at_before_closed_at
    errors.add(:closed_at, I18n.t('supervisor.periods.validate.period.closed_at')) if (opened_at.present? && closed_at.present? && opened_at > closed_at)
  end

  def ended_at_before_opened_at
    errors.add(:ended_at, I18n.t('supervisor.periods.validate.period.opened_at')) if (ended_at.present? && opened_at.present? && ended_at > opened_at)
  end

end
