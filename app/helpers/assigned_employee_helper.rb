module AssignedEmployeeHelper

  def input_staff_visible?(unit_id)
    params[:justification] || AssignedEmployee.where(unit_id: unit_id, staff_of_type: 'UnitJustified').count > 0
  end

  def staff_justification_class(unit_id, period_id)
    if AssignedEmployee.where(unit_id: unit_id, period_id: period_id, staff_of_type: 'UnitJustified').no_justification_verified.count == 0
      "icon-check"
    else
      "icon-x"
    end
  end

  def staff_justification_text(unit_id, period_id)
    if AssignedEmployee.where(unit_id: unit_id, period_id: period_id, staff_of_type: 'UnitJustified').no_justification_verified.count == 0
      "Efectivos reales. Verificados"
    else
      "Efectivos reales. Pte. verificación"
    end
  end


  def get_staff(type, proc, group, unit, period)
    if type == 'SubProcess'
      ids = proc.indicators.ids
      type = 'Indicator'
    else
      ids =  proc.id
    end
    ae = AssignedEmployee.where(staff_of_id: ids, staff_of_type: type, official_group_id: group.id, unit_id: unit.id, period_id: period.id).count
    if ae > 0
      ae = AssignedEmployee.where(staff_of_id: ids, staff_of_type: type, official_group_id: group.id, unit_id: unit.id, period_id: period.id).sum(:quantity)
    else
      ae = nil
    end
    if ae.nil? && type == "UnitJustified"
      ae = AssignedEmployee.where(staff_of_id: ids, staff_of_type: "Unit", official_group_id: group.id, unit_id: unit.id, period_id: period.id).sum(:quantity)
    end
    return ae.nil? ? nil : format_number(ae)
  end

  def has_justification?(unit_id, period_id)
    AssignedEmployee.where(staff_of_type: "UnitJustified", staff_of_id: unit_id, unit_id: unit_id, period_id: period_id).count > 0
  end

end