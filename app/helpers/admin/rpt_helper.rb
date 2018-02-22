module Admin::RptHelper
  def organization_changes?(organization)
    return false if organization == @organization_ant
    @organization_ant = organization
    true
  end
end
