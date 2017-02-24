module AssignedEmployeeHelper

  def input_staff_visible?(unit_id)
    (params[:justification] && !params[:justification].empty?) || AssignedEmployee.where(unit_id: unit_id, staff_of_type: 'UnitJustified').count > 0
  end

  def staff_verified_class(unit_id, period_id)
    if AssignedEmployee.where(unit_id: unit_id, period_id: period_id, staff_of_type: 'UnitJustified').no_justification_verified.count == 0
      "success"
    else
      "warning"
    end
  end

  def staff_verified_text(unit_id, period_id)
    if AssignedEmployee.where(unit_id: unit_id, period_id: period_id, staff_of_type: 'UnitJustified').no_justification_verified.count == 0
      "Modificación verificada"
    else
      "Pendiente de verificación"
    end
  end

  def get_staff(type, proc, group, unit, period)
    ids =  proc.id
    if type == 'SubProcess'
      # unicamente el periodo de Distrito 2015 tiene datos en subprocesos en lugar de en indicadores
      period_2015 = Period.find_by_description('PERIODO DE ANÁLISIS: AÑO 2015')
      if period != period_2015
        ids = proc.indicators.ids
        type = 'Indicator'
      end
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

  def  justification_text(unit_id, period_id)
    ae = AssignedEmployee.where(staff_of_type: "UnitJustified", staff_of_id: unit_id, unit_id: unit_id, period_id: period_id).take
    ae.nil? ? '' : ae.justification
  end
end