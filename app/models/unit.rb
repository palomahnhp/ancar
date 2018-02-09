class Unit < ActiveRecord::Base
  resourcify
  belongs_to :unit_type
  belongs_to :organization

  has_many :assigned_employees, as: :staff_of, :dependent => :destroy
  has_many :assigned_employees_changes
  has_many :entry_indicators, inverse_of: :unit, :dependent => :destroy
  has_many :sub_processes, :dependent => :destroy
  has_many :approvals
  has_many :validations

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

  def employees_change(period)
    change_data = { id: '', justified_by: 'No', justified_at: '' }
    change = self.assigned_employees_changes.by_period(period).take
    if change.present?
      change_data[:id] =  change.id
      change_data[:justified_by] =  change.justified_by
      change_data[:justified_at] =  change.justified_at
    end
    return change_data
  end

  def approval(period)
    approval_data = { id: '', approval_by: 'No', approval_at: '', end: '' }
    approval = self.approvals.by_period(period).take
    if approval.present?
      approval_data[:id] =  approval.approval_by
      approval_data[:approval_by] =  approval.approval_by
      approval_data[:approval_at] =  approval.approval_at
      approval_data[:end] =  'icon-check'
    end
    approval_data
  end

  def validation(period)
    validation_data = { id: '', updated_by: 'No', created_at: '', success: 'nok',
                        end: 'No se han validado los datos' }
    validation = self.validations.by_period(period).take
    if validation.present?
      validation_data[:id]         =  validation.id
      validation_data[:updated_by] =  validation.updated_by
      validation_data[:created_at] =  validation.created_at

      if validation.key == 'success_validation'
        validation_data[:success] = 'ok'
        validation_data[:end] = 'Datos correctos'
      else
        validation_data[:end] = 'Datos con errores'
      end
    end
    validation_data
  end

end
