class UnitStatus

  attr_accessor :unit_status, :unit_statuses, :period

  def initialize(period_id)
    false if period_id.blank?
    @unit_statuses = []
    @period = Period.find(period_id)
  end

  def create(unit_id)
    @unit   = Unit.find(unit_id)

    fill_header
    fill_approval
    fill_employee_change

    @unit_statuses << @unit_status
  end

  def create_all
    @period.organization_type.organizations.each do |organization|
      organization.units.each do |unit|
        self.create(unit.id)
      end
    end
  end

  def count
    @unit_statatuses.count
  end

  def noks(organization_id)
    @noks = self.unit_statuses.select {
        |u| ((u[:organization_id] == organization_id) && !(u[:approval_at].is_a? Date))
    }.count
  end

  private

  def approval(period_id, unit_id)
    @approval = Approval.find_by(period_id: period_id, unit_id: unit_id)
  end

  def employees_change(period_id, unit_id)
    @employees_change = AssignedEmployeesChange.find_by(period_id: period_id, unit_id: unit_id)
  end

  def fill_header
    organization = @unit.organization
    organization_type = organization.organization_type
    @unit_status = {}
    @unit_status[:organization_type] = organization_type.description
    @unit_status[:organization_id] = organization.id
    @unit_status[:organization_description] = organization.description
    @unit_status[:unit_id] = @unit.id
    @unit_status[:unit_description] = @unit.description_sap
  end

  def fill_approval
    if approval(period.id, @unit.id).present?
      @unit_status[:approval_id] = @approval.id
      @unit_status[:approval_at] = @approval.approval_at
      @unit_status[:approval_by] = @approval.approval_by
    else
      @unit_status[:approval_id] = 0
      @unit_status[:approval_at] = 'No'
      @unit_status[:approval_by] = ''
    end
  end

  def fill_employee_change
    if employees_change(period.id, @unit.id).present?
      @unit_status[:employees_change_id] = @employees_change.id
      @unit_status[:employees_change_at] = @employees_change.justified_at
      @unit_status[:employees_change_by] = @employees_change.justified_by
    else
      @unit_status[:employees_change_id] = 0
      @unit_status[:employees_change_at] = 'No'
      @unit_status[:employees_change_by] = ''
    end
  end
end