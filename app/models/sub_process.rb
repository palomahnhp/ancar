class SubProcess < ActiveRecord::Base
  has_many :tasks, :dependent => :destroy
  has_many :indicators, through: :tasks, :dependent => :destroy
  has_many :assigned_employees, as: :staff, :dependent => :destroy

  belongs_to :main_process
  belongs_to :unit_type
  belongs_to :item, -> { where item_type: "sub_process" }

  validates :main_process_id, presence: true
  validates :item_id, presence: true

end
