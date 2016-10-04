class MainProcess < ActiveRecord::Base
  has_many :sub_processes, :dependent => :destroy
  has_many :tasks, through: :sub_processes, :dependent => :destroy
  belongs_to :period
  belongs_to :item, -> { where item_type: "main_process" }

  validates :period_id, presence: true
  validates :item_id, presence: true

  def copy(periodo_destino_id, current_user_login)
    mp = MainProcess.create(self.attributes.merge(id: nil, period_id: periodo_destino_id, updated_by: current_user_login))
    self.sub_processes.each do |sp|
      sp.copy(mp.id, current_user_login)
    end
  end

end
