class Unit < ActiveRecord::Base
  belongs_to :unit_type
  belongs_to :organization

  has_many :assigned_employees, as: :staff_id, :dependent => :destroy
end
