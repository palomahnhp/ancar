class SubProcess < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :tasks, :dependent => :destroy
  has_many :indicators, through: :tasks, :dependent => :destroy
  has_many :assigned_employees, as: :staff_of, :dependent => :destroy

  belongs_to :main_process
  belongs_to :unit_type
  belongs_to :unit
  belongs_to :item, -> { where item_type: 'sub_process' }

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

  def self.description(id)
    self.find(id).item.description
  end

  def self.validate_in_out_stock(period, unit)
    errors_in_out_stock = Hash.new
    period.main_processes.each do |main_process|
      main_process.sub_processes.each do |sub_process|
        stock = sub_process.get_amount('stock', unit.id)
        unless stock == 0
          in_amount = sub_process.get_amount('in', unit.id)
          out_amount = sub_process.get_amount('out', unit.id)
          errors_in_out_stock[sub_process.id] = [out_amount, in_amount, stock]  if out_amount > stock + in_amount
        end
      end
    end
    return errors_in_out_stock
  end

  def get_amount(type,  unit_id)
    EntryIndicator.where(indicator_metric: IndicatorMetric.send(type).where(indicator_id: self.indicators.ids),
                         unit_id: unit_id).sum(:amount)
  end

end
