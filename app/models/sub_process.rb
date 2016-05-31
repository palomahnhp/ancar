class SubProcess < ActiveRecord::Base
  has_many :tasks
  has_many :indicators, through: :tasks
  has_many :assigned_employees, as: :staff

  belongs_to :main_process
  belongs_to :item, -> { where item_type: "sub_process" }

  validates :main_process_id, presence: true
  validates :item_id, presence: true

end
