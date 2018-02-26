module Admin::RptHelper
  def organization_changes?(organization)
    return false if organization == @organization_ant
    @organization_ant = organization
    true
  end

  def assigned_units(year, unit)
    units = []
    UnitRptAssignation.by_year(year).by_unit(unit).select(:sapid_unit).to_a.each do |unit|
      units << unit.sapid_unit
    end
    units
  end
end
