class SubProcess < ActiveRecord::Base
  has_many :tasks, :dependent => :destroy
  has_many :indicators, through: :tasks, :dependent => :destroy
  has_many :assigned_employees, as: :staff_of, :dependent => :destroy

  belongs_to :main_process
  belongs_to :unit_type
  belongs_to :item, -> { where item_type: "sub_process" }

  validates :main_process_id, presence: true
  validates :unit_type_id, presence: true
  validates :item_id, presence: true
  validates :order, presence: true

  def copy(mp_id, current_user_login)
    sp = SubProcess.create(self.attributes.merge(id: nil, main_process_id: mp_id, updated_by: current_user_login))
    tasks.each do |tk|
      tk.copy(sp.id, current_user_login)
    end
  end

   def is_empty?
     self.tasks.count == 0
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

  def get_stock(unit_id)
    stock = 0
    self.indicators.each do |indicator|
      ti = TotalIndicator.for_stock.where(indicator_metric: indicator.indicator_metrics.ids).take
      stock += ti.indicator_metric.entry_indicators.where(unit_id: unit_id).sum(:amount)  unless ti.nil?
    end
    return stock
  end

    def get_amount(type,  unit_id)
      in_amount = 0
      ti = TotalIndicator.for_sub_process.eval(type).where(indicator_metric: IndicatorMetric.where(indicator_id: self.indicators.ids))
      in_amount = 0
      ti.each do |total_indicator|
        in_amount += total_indicator.indicator_metric.amount(@unit.id)
      end
      return in_amount
    end

end
