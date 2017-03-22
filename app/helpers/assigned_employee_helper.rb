module AssignedEmployeeHelper

  def input_staff_visible?(unit_id, period_id)
    (params[:justification] && !params[:justification].empty?) || AssignedEmployeesChange.where(unit_id: unit_id, period_id: period_id).count > 0
  end

  def staff_verified_class(unit_id, period_id)
    if AssignedEmployeesChange.where(unit_id: unit_id, period_id: period_id).not_verified.count > 0
      "warning"
    else
      "success"
    end
  end

  def staff_verified_text(unit_id, period_id)
    if AssignedEmployeesChange.where(unit_id: unit_id, period_id: period_id).not_verified.count > 0
      t('AssignedEmployeesChange.text.not_verified')
    else
      t('AssignedEmployeesChange.text.verified')
    end
  end

  def get_staff(type, proc, unit, period, class_of = '')

    @period_2015 ||= Period.find_by_description('PERIODO DE ANÁLISIS: AÑO 2015')

    if type == 'SubProcess' &&  period != @period_2015
      ids = proc.indicators.ids
      type = 'Indicator'
    else
      ids = []
      ids <<  proc.id
    end
    if type == 'Unit'
      @unit_assigned_employees ||= AssignedEmployee.where(unit_id: unit.id, period_id: period.id).order(:official_group_id).
          group(:staff_of_type, :official_group_id).
          pluck(:staff_of_type, :official_group_id, 0 , 'count(id)', 'sum(quantity)')
      if class_of.empty?
        return_array = @unit_assigned_employees.select{ |t| t[0] == type }
      elsif class_of == 'Assigned'
        return_array = @unit_assigned_employees.select{ |t| t[0] == 'Indicator'}
      end
    else
     @assigned_employees ||= AssignedEmployee.where(unit_id: unit.id, period_id: period.id).order(:official_group_id).
        group(:staff_of_id, :staff_of_type, :official_group_id).
        pluck(:staff_of_id, :staff_of_type, :official_group_id, 'count(id)', 'sum(quantity)')
     return_array = @assigned_employees.select{ |t| ids.include?(t[0])  }
    end
     return return_array
  end

  def has_justification?(unit_id, period_id)
    AssignedEmployeesChange.where(unit_id: unit_id, period_id: period_id).count > 0
  end

  def justification_verified?(unit_id, period_id)
    @justification_verified ||= AssignedEmployeesChange.where(unit_id: unit_id, period_id: period_id).not_verified.count == 0
  end

  def  justification_text(unit_id, period_id)
    ae = AssignedEmployeesChange.where(unit_id: unit_id, period_id: period_id).take
    ae.nil? ? '' : ae.justification
  end

  def official_groups
    @official_groups ||=  OfficialGroup.all
  end
end