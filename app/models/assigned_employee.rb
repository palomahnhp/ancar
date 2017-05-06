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

  def self.staff_for_unit(period, unit)
    message = []

    OfficialGroup.all.each do |official_group|
      staff_real= self.staff_from_unit_justificated(unit, period, official_group)
      staff_indicator = self.staff_from_indicator(unit, period, official_group)
      staff_unit = self.staff_from_unit(unit, period, official_group)

      if staff_real.present?
        unless staff_real == staff_indicator
          message << official_group.description
        end
      elsif
        unless staff_unit == staff_indicator
          message << official_group.description
        end
      end
    end
    return message
  end

  def self.staff_quantity(type, unit_id)
     where(staff_of_type: type.class.name, staff_of: type.id, unit_id: unit_id).sum(:quantity)
  end

  def self.cancel(period, unit)
    self.where(period: period, unit_id: unit.id, staff_of_type: "UnitJustified").delete_all

  end

  def self.delete_all_by_group(official_group_id, type, process_id, period_id, unit_id)
    self.where(official_group_id: official_group_id, staff_of_type: type, staff_of_id: process_id, period_id: period_id, unit_id: unit_id).delete_all
  end

  def get_by_group(official_group_id, type, process_id)
    self.find_or_create_by(official_group_id: official_group_id, staff_of_type: type, staff_of_id: process_id, period_id: @period.id, unit_id: @unit.id)
  end

  private

    def self.staff_from_unit(unit, period, official_group)
      staff_from('Unit', unit, period, official_group, unit.id)
    end

    def self.staff_from_indicator(unit, period, official_group)
      staff_from('Indicator', unit, period, official_group)
    end

    def self.staff_from_unit_justificated(unit, period, official_group)
      staff_from('UnitJustified', unit, period, official_group, unit.id)
    end

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
