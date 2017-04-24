class Task < ActiveRecord::Base
  has_many :indicators, :dependent => :destroy
  belongs_to :sub_process
  belongs_to :item, -> { where item_type: 'task' }

  validates :sub_process_id, presence: true
  validates :item_id, presence: true

  def copy(sp_id, current_user_login)
    tk = Task.create(self.attributes.merge(id: nil, sub_process_id: sp_id, updated_by: current_user_login))
    indicators.each do |i|
      i.copy(tk.id, current_user_login)
    end
  end

  def is_empty?
    self.indicators.count == 0
  end

  def main_process
    sub_process.main_process
  end

  def period
    main_process.period
  end

  def modifiable?
    period.modifible?
  end

  def eliminable?
    period.eliminable?
  end
end
