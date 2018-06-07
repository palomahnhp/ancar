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

  # Abierta actualizacion de datos por el interlocutor
  def open_entry?
    opened_at <=  DateTime.now.to_date  && closed_at >=  DateTime.now.to_date
  end

  # Cerrada actualizacion de datos por el interlocutor
  def close_entry?
    closed_at <  DateTime.now
  end

  def modifiable?
#   !close_entry?
    not_yet_open?
  end

# Aun no ha comenzado la entrada de datos
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
    self.all.order(:ended_at).collect { |v| [v.description, v.id] }
  end

  def self.look_up_description(description)
    self.find_by_description(description)
  end

  def self.select_year
    unscoped.order_by_started_at.collect { |period| period.started_at.year }.uniq
  end

  def structure
    structure = []
    main_processes.includes(:sub_processes).order(:order).each do |mp|
      mp.sub_processes.each do |sp|
        sp.tasks.each do |tk|
          tk.indicators.order(:code).each do |ind|
            ind.indicator_metrics.order(:code).each do |im|
              structure << [{'Periodo': self.description},
                            {'Cód.indicador': ind.full_code},
                            {'Proceso/Bloque': mp.item.description},
                            {'Subproceso/Proceso': sp.item.description},
                            {'Indicador': ind.item.description},
                            {'Métrica': im.metric.item.description},
                            {'Tipo': im.in_out_type},
                            {'Procedencia': im.data_source},
                            {'Trámite': im.procedure},
                            {'Fuente': im.source_description},
                            {'Auto': im.source_fixed}]
            end
          end
        end
      end
    end
    structure
  end

  def self.export_columns
    %w(description
       main_processes
       unit_type
       sub_processes
       code
       indicators
       source
       metrics
       in_out_type
       data_source
       procedure
      )
  end

  def self.sql_export
    Period.find_by_sql(
    "select main_processes.order, items_mp.description, sub_processes.order, items_sp.description,
             indicators.code, indicator_metrics.in_out_type,
             items_ind.description, items_metric.description, items_source.description, items_mp.description
         from periods
        join organizations on organizations.organization_type_id = periods.organization_type_id
        join main_processes on main_processes.period_id   = periods.id
        join items as items_mp on items_mp.item_type = 'main_process' and items_mp.id = main_processes.item_id
        join sub_processes on sub_processes.main_process_id   = main_processes.id
        join items as items_sp on items_sp.item_type = 'sub_process' and items_sp.id = sub_processes.item_id
        join tasks as tasks on tasks.id = sub_processes.id
        join indicators on indicators.task_id   = tasks.id
        join items as items_ind on items_ind.item_type = 'indicator' and items_ind.id = indicators.item_id
        join indicator_metrics on indicator_metrics.indicator_id   = indicators.id
        join metrics on metrics.id = indicator_metrics.metric_id
        join items as items_metric on items_metric.item_type = 'metric' and items_metric.id = metrics.item_id
        join indicator_sources on indicator_sources.indicator_metric_id = indicator_metrics.id
        join sources on sources.id = indicator_sources.source_id
        join items as items_source on items_source.item_type = 'source' and items_source.id = sources.item_id
       where periods.id =  7 -- and organizations.id = 29
    group by main_processes.order, items_mp.description, sub_processes.order, items_sp.description,
             indicators.code, indicator_metrics.in_out_type,
             items_ind.description, items_metric.description, items_source.description
    order by main_processes.order, sub_processes.order, indicators.code
    limit 1  ")

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
