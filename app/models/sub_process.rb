class SubProcess < ActiveRecord::Base
  has_many :tasks, :dependent => :destroy
  has_many :indicators, through: :tasks, :dependent => :destroy
  has_many :assigned_employees, as: :staff_of, :dependent => :destroy

  belongs_to :main_process
  belongs_to :unit_type
  belongs_to :item, -> { where item_type: "sub_process" }

  validates :main_process_id, presence: true
  validates :item_id, presence: true

  def copy(mp_id, current_user_login)
    sp = SubProcess.create(self.attributes.merge(id: nil, main_process_id: mp_id, updated_by: current_user_login))
    tasks.each do |tk|
      tk.copy(sp.id, current_user_login)
    end
  end

end
