class AssignedEmployee < ActiveRecord::Base
  resourcify
  belongs_to :staff_of, polymorphic: true
  belongs_to :official_group
  belongs_to :period

  validates_inclusion_of :staff_of_type, in: %w[Unit Indicator UnitJustified]
  validates_numericality_of :quantity

  scope :no_justification_verified, -> { where(:verified_at => nil) }
  scope :by_period,                 ->(period) { where( period: period) }
  scope :by_unit,                   ->(unit) { where( unit_id: unit) }
  scope :by_official_group,         ->(official_group) { where( official_group: official_group) }
  scope :unit_justified,            -> { where( staff_of_type: "UnitJustified") }
  scope :by_staff_of_type,          ->(type) { where( staff_of_type: type) }


  def copy(period_destino_id, current_user_login)
    AssignedEmployee.create(self.attributes.merge(id: nil, period_id: period_destino_id, updated_at: current_user_login))
  end

  def quantity=(val)
    val.sub!(',', '.') if val.is_a?(String)
    self['quantity'] = val
  end

  def self.staff_for_unit(period, unit)
    message = []
    lower_staff = Setting.find_by_key("validations.lower_staff.#{period.organization_type.acronym}")
    upper_staff = Setting.find_by_key("validations.upper_staff.#{period.organization_type.acronym}")

    OfficialGroup.all.each do |official_group|
      staff_quantity = self.staff_from_indicator(unit, period, official_group)

      if AssignedEmployeesChange.unit_justified(unit.id, period.id)
        staff_unit= self.staff_from_unit_justificated(unit, period, official_group)
      else
        staff_unit = self.staff_from_unit(unit, period, official_group)
      end
      case
        when staff_unit <  staff_quantity
          unless  upper_staff.present?  && upper_staff.enabled?
            message << official_group.description
          end
        when staff_unit >  staff_quantity
          unless lower_staff.present? && lower_staff.enabled?
            message << official_group.description
          end
      end
    end
    return message
  end

  def self.load_unit_staff(period, unit)
      by_period(period).by_unit(unit)
  end

  def self.staff_quantity(type, unit_id)
     where(staff_of_type: type.class.name, staff_of: type.id, unit_id: unit_id).sum(:quantity)
  end

  def self.cancel(period_id, unit_id)
    self.where(period_id: period_id, unit_id: unit_id, staff_of_type: "UnitJustified").delete_all
  end

  def self.initialize(period_id, unit_id, user)
    self.where(period_id: period_id, unit_id: unit_id, staff_of_type: "Unit").each do |unit_staff|
      self.create(period_id: unit_staff.period_id, unit_id: unit_staff.unit_id, official_group_id: unit_staff.official_group_id,
                  staff_of_id: unit_staff.staff_of_id, staff_of_type: "UnitJustified", quantity: unit_staff.quantity,
                  updated_by: user.login)
    end
  end

  def self.initialize_unit(period_id, unit_id, user, employees)
    employees.each_index do |employee|
      self.find_or_create_by!(period_id: period_id, unit_id: unit_id,
                              official_group_id: OfficialGroup.find_by(employee[:group]).id,
                              staff_of_id: unit_id,
                              staff_of_type: "Unit",
                              quantity: employee[:unit],
                              updated_by: user.login)
    end
  end

  def self.delete_all_by_group(official_group_id, type, process_id, period_id, unit_id)
    self.where(official_group_id: official_group_id, staff_of_type: type, staff_of_id: process_id, period_id: period_id, unit_id: unit_id).delete_all
  end

  def self.set_by_group(official_group_id, type, process_id, period_id, unit_id)
    self.find_or_create_by(official_group_id: official_group_id, staff_of_type: type, staff_of_id: process_id, period_id: period_id, unit_id: unit_id)
  end

  def self.staff_from_unit(unit, period, official_group)
    staff_from('Unit', unit, period, official_group, unit.id)
  end

  def self.staff_from_indicator(unit, period, official_group)
    staff_from('Indicator', unit, period, official_group)
  end

  def self.staff_from_unit_justificated(unit, period, official_group)
    staff_from('UnitJustified', unit, period, official_group, unit.id)
  end

  private

    def self.staff_from(where, unit, period, official_group, id = nil )
      if id.nil?
        self.where(staff_of_type: where, unit_id: unit.id, period_id: period.id,
                   official_group: official_group.id).sum(:quantity).to_f
      else
        self.where(staff_of_type: where, staff_of_id: id, unit_id: unit.id, period_id: period.id,
                               official_group: official_group.id).sum(:quantity).to_f
      end
    end

end
