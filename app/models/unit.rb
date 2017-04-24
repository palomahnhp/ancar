class Unit < ActiveRecord::Base
  resourcify
  belongs_to :unit_type
  belongs_to :organization

  has_many :assigned_employees, as: :staff_of, :dependent => :destroy
  has_many :entry_indicators, inverse_of: :unit, :dependent => :destroy
  has_many :sub_processes, :dependent => :destroy
  has_many :approvals, as: :subject

  accepts_nested_attributes_for :entry_indicators, reject_if: :reject_entry_inidicators

  def reject_entry_indicators(attributed)
    attributed['amount'].blank?
  end
end
