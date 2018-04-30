class Period < ActiveRecord::Base
  resourcify
  include PublicActivity::Common
  #  tracked owner: Proc.new{ |controller, model| controller && controller.current_user }

  has_many :main_processes, :dependent => :destroy
  has_many :assigned_employees, :dependent => :destroy
  has_many :entry_indicators, :dependent => :destroy

  belongs_to :organization_type, :inverse_of => :periods

  validates :description, presence: true,  length: { in: 4..100 }
  validates :organization_type_id, presence: true
  validates :opened_at, presence: true
  validates :closed_at, presence: true
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validate :started_at_before_ended_at
  validate :opened_at_before_closed_at
  validate :ended_at_before_opened_at

  default_scope { order(organization_type_id: :asc, ended_at: :desc) }
  scope :order_by_started_at, -> { order(started_at: :desc) }
  scope :show_status, -> { where(hide_status: false) }
  scope :by_organization_type, -> (organization_type) { where(organization_type: organization_type) }
  scope :by_year, -> (year) { where(started_at: year.to_s + '01' + '01') }

  def open_entry?
    opened_at <=  DateTime.now.to_date  && closed_at >=  DateTime.now.to_date
  end

  def close_entry?
    closed_at <  DateTime.now
  end

  def modifiable?
#   !close_entry?
    not_yet_open?
  end

  def not_yet_open?
    opened_at >  DateTime.now
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
  end

  def indicators(unit)
    indicators = []
    self.main_processes.where("organization_id IS ? OR organization_id = ?", nil, unit.organization_id).each do |main_process|
      main_process.sub_processes_unit(unit).each do |sub_process|
        indicators << sub_process.indicators
      end
    end
    indicators
  end

  def is_from?(acronym)
    organization_type.is_acronym?(acronym)
  end

  def self.select_options
    self.all.order(:ended_at).collect { |v| [ v.description, v.id ] }
  end

  def self.look_up_description(description)
    self.find_by_description(description)
  end

  def self.select_year
    unscoped.order_by_started_at.collect { |period| period.started_at.year }.uniq
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
