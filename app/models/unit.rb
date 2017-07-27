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

  def self.select_options(user = nil)
    if user.present?
      user.auth_units.collect { |ar| ar.collect { |v| [ v.description_sap, v.id ] }}
      units = ''
      user.auth_units.each do |ar|
        units = ar.collect { |u| [ u.description_sap, u.id ]}
#          units << [ u.description_sap, u.id ]
#        end
      end
    else
      units = self.all.collect { |v| [ v.description, v.id ] }
    end
    return units
  end

end
