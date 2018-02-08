class Indicator < ActiveRecord::Base
  resourcify
  has_many :indicator_sources, :dependent => :destroy
  has_many :indicator_metrics, :dependent => :destroy

  has_many :metrics, through: :indicator_metrics
  has_many :entry_indicators, through: :indicator_metrics
  has_many :total_indicators, through: :indicator_metrics
  has_many :summary_types, through: :total_indicators

  has_many :sources, through: :indicator_sources

  belongs_to :task
  belongs_to :item, -> { where item_type: 'indicator' }

  validates :item_id, presence: true
  validates :order, presence: true

  validates_associated :indicator_metrics
  validates_associated :indicator_sources

  def copy(tk_id, current_user_login)
    i = Indicator.create(self.attributes.merge(id: nil, task_id: tk_id, updated_by: current_user_login))
    indicator_metrics.each do |im|
      im.copy(i.id)
    end
  end

  def is_empty?
    true
  end

  def sub_process
    task.sub_process
  end

  def main_process
    sub_process.main_process
  end

  def period
    main_process.period
  end

  def modifiable?
    period.modifiable?
  end

  def eliminable?
    period.eliminable?
  end

  def amount(unit_id)
    amount = 0
    self.indicator_metrics.each do |indicator_metric|
      amount += indicator_metric.amount(unit_id)
    end
    return amount
  end

  def self.description(id)
    Indicator.find(id).item.description
  end

  def self.validate_staff_for_entry(period, unit)
    entry_without_staff = []
    staff_without_entry = []
    period.main_processes.each do |main_process|
      main_process.sub_processes.each do |sub_process|
        staff_quantity = indicator_amount = 0
        sub_process.tasks.each do |task|
          task.indicators.each do |indicator|
            indicator_amount   = indicator.amount(unit.id).to_f
            staff_quantity     = AssignedEmployee.staff_quantity(indicator, unit.id)
            if staff_quantity.zero? && indicator_amount > 0
              error = Indicator.description(indicator.id) + " => cantidad: " +
                      indicator_amount.to_s + " puestos asignados: " + staff_quantity.to_s
              entry_without_staff.push(error)
            elsif staff_quantity > 0 && indicator_amount.zero?
              error = Indicator.description(indicator.id) + " => cantidad: " +
                      indicator_amount.to_s + " puestos asignados: " + staff_quantity.to_s
              staff_without_entry.push(error)
            end
          end
        end
      end
    end
    return [entry_without_staff, staff_without_entry]
  end
end
