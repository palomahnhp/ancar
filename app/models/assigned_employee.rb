class AssignedEmployee < ActiveRecord::Base
  resourcify
  belongs_to :staff_of, polymorphic: true
  belongs_to :official_group
  belongs_to :period

  validates_inclusion_of :staff_of_type, in: %w[Unit Indicator UnitJustified]

  scope :no_justification_verified,  -> { where(:verified_at => nil) }

  def copy(period_destino_id, current_user_login)
    AssignedEmployee.create(self.attributes.merge(id: nil, period_id: period_destino_id, updated_at: current_user_login))
  end

  def quantity=(val)
    val.sub!(',', '.') if val.is_a?(String)
    self['quantity'] = val
  end

  def self.exceeded_staff_for_unit(period, unit)
    message = []
    OfficialGroup.all.each do |official_group|
      if AssignedEmployee.where(staff_of_type: 'Unit', staff_of_id: unit.id, unit_id: unit.id, period_id: period.id,
                                official_group: official_group.id).sum(:quantity).to_f <
          AssignedEmployee.where(staff_of_type: 'Indicator', unit_id: unit.id, period_id: period.id,
                                 official_group: official_group.id).sum(:quantity).to_f
        if AssignedEmployee.where(staff_of_type: 'UnitJustified', staff_of_id: unit.id, unit_id: unit.id, period_id: period.id,
                                  official_group: official_group.id).sum(:quantity).to_f <
            AssignedEmployee.where(staff_of_type: 'Indicator', unit_id: unit.id, period_id: period.id,
                                   official_group: official_group.id).sum(:quantity).to_f
          message << official_group.description
        end
      end
    end
    return message
  end

  def self.staff_quantity(type, unit_id)
     where(staff_of_type: type.class.name, staff_of: type.id, unit_id: unit_id).sum(:quantity)
  end
end
