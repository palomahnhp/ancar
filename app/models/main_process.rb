class MainProcess < ActiveRecord::Base
  has_many :sub_processes, :dependent => :destroy
  has_many :tasks, through: :sub_processes, :dependent => :destroy
  has_many :indicators, through: :tasks, :dependent => :destroy
  has_many :approvals, as: :subject

  belongs_to :organization
  belongs_to :period
  belongs_to :item, -> { where item_type: 'main_process' }

  validates :period_id, presence: true
  validates :item_id, presence: true
  validates :order, presence: true

  def copy(periodo_destino_id, current_user_login)
    mp = MainProcess.create(self.attributes.merge(id: nil, period_id: periodo_destino_id, updated_by: current_user_login))
    self.sub_processes.each do |sp|
      sp.copy(mp.id, current_user_login)
    end
  end

  def is_empty?
   self.sub_processes.count == 0
  end

  def modifiable?
    period.modifiable?
  end

  def eliminable?
    period.eliminable?
  end

  def show_in_entry(unit)
    sub_processes_unit(unit).count  > 0 && (self.organization_id.nil? || self.organization_id == unit.organization.id)
  end

  def sub_processes_unit(unit)
    self.sub_processes.where(unit_type_id: unit.unit_type_id).order(:order)
  end

  def organization_group
    self.organization_id.nil? ? I18n.t('main_process.organization_group.generic'): Organization.find(organization_id).description
  end
end
