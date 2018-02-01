module AssignedEmployeeHelper
  def input_staff_visible?(unit_id, period_id)
    (params[:justification] && params[:justification].blank?) || AssignedEmployeesChange.where(unit_id: unit_id, period_id: period_id).count > 0

  end

  def staff_verified_class(unit_id, period_id)
    if AssignedEmployeesChange.where(unit_id: unit_id, period_id: period_id).not_verified.count > 0
      'warning'
    else
      'success'
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

    @period_2015 ||= Period.look_up_description('PERIODO DE ANÁLISIS: AÑO 2015')

    if (type == 'SubProcess' &&  period != @period_2015) || type == 'MainProcess'
      ids = proc.indicators.ids
      type = 'Indicator'
    else
      ids = []
      ids <<  proc.id
    end
    if type == 'Unit' || type == 'UnitJustified'
      @unit_assigned_employees ||= AssignedEmployee.where(unit_id: unit.id, period_id: period.id).order(:official_group_id).
          group(:staff_of_type, :official_group_id).
          pluck(:staff_of_type, :official_group_id, 0 , 'count(id)', 'sum(quantity)')
      if class_of.empty?
        return_array = @unit_assigned_employees.select{ |t| t[0] == type }
      elsif class_of == 'Assigned'
        return_array = @unit_assigned_employees.select{ |t| ( t[0] == 'SubProcess' || t[0] == 'Indicator')}
      end
    elsif type == 'Indicator'
      @assigned_employees ||= AssignedEmployee.where(unit_id: unit.id, period_id: period.id, staff_of_type: 'Indicator').order(:official_group_id).
        group(:staff_of_id, :staff_of_type, :official_group_id).
        pluck(:staff_of_type, :official_group_id, 'count(id)', 'sum(quantity)', :staff_of_id)
      return_array = @assigned_employees.select{ |t| ids.include?(t[4])  }
    elsif type == 'SubProcess'
       @sp_assigned_employees ||= AssignedEmployee.where(unit_id: unit.id, period_id: period.id, staff_of_type: 'SubProcess').order(:official_group_id).
           group(:staff_of_id, :staff_of_type, :official_group_id).
           pluck(:staff_of_type, :official_group_id, 'count(id)', 'sum(quantity)', :staff_of_id)
       return_array = @sp_assigned_employees.select{ |t| ids.include?(t[4])  }
    end
     return return_array
  end

  def display_staff(of, process, unit, period, gr_id, pos, class_type = '')
    quantity = 0
    staff = get_staff(of, process, unit, period, class_type)
    if staff.present?
      staff = staff.select{|st| st[1] == gr_id}
      if staff.present?
        if of == "SubProcess" || of == "MainProcess"
          staff.map{ |st| quantity += st[3] unless st[3].nil? }
        else
          quantity = staff.first[pos]
        end
      else
        quantity = nil
      end
    else
    end
     return quantity
  end

  def has_justification?(unit_id, period_id)
    AssignedEmployeesChange.where(unit_id: unit_id, period_id: period_id).count > 0
  end

  def justification_verified?(unit_id, period_id)
#    @justification_verified ||= AssignedEmployeesChange.where(unit_id: unit_id, period_id: period_id).not_verified.count == 0
    true
  end

  def  justification_text(unit_id, period_id)
    ae = AssignedEmployeesChange.where(unit_id: unit_id, period_id: period_id).take
    ae.nil? ? '' : ae.justification
  end

  def quantity_equal?(official_group_id, type, process_id, quantity)
    AssignedEmployee.where(official_group_id: official_group_id, staff_of_type: 'Unit', staff_of_id: process_id, period_id: @period.id, unit_id: @unit.id).sum(:quantity) == quantity.to_f
  end
end