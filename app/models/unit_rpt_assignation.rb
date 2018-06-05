class UnitRptAssignation < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user} ,
          :params => {:id => :id,
                      :description     => proc {|controller, model_instance| model_instance.indicator_metric.indicator.item.description},
                      :amount          => proc {|controller, model_instance| model_instance.amount.to_s},
                      :imported_amount => proc {|controller, model_instance| model_instance.imported_amount.to_s},
                     }

  belongs_to :unit
  belongs_to :organization

  scope :by_year,         ->(year) { where( year: year ) }
  scope :by_organization, ->(organization) { where( organization: organization ) }
  scope :by_unit,         ->(unit) { where( unit: unit ) }
  scope :assigned,        -> { where.not( unit_id: nil) }
  scope :unassigned,      -> { where( unit_id: nil) }

  def self.init(year)
    Organization.all.find_each do |organization|
      organization.rpts.select(:sapid_unidad).group(:sapid_unidad).each do |sap_unit|
        item = find_or_create_by!(year: year, organization: organization,
                                  sapid_unit: sap_unit.sapid_unidad,
                                  den_unit: Rpt.find_by(sapid_unidad: sap_unit.sapid_unidad).den_unidad )
        item.unit =  Unit.find_by(sap_id: sap_unit.sapid_unidad).presence if item.unit.blank?
        item.save
      end
    end
  end

  def self.copy(year)
    by_year(year - 1).each do |record|
      new_record = record.dup
      new_record.year = year
      new_record.save
    end
  end

  def self.update(year, assigns, unassigns)
    assigns.each do |assign|
      next if assign[1].blank?
      unit = find_by(sapid_unit: assign[0], year: year)
      unit.unit_id = assign[1]
      unit.save
    end
    if unassigns.present?
      unassigns.each do |unassign|
        next if unassign[1].blank?
        unit = find_by(sapid_unit: unassign[0], year: year)
        unit.unit_id = nil
        unit.save
      end
    end
  end

  def self.export_columns
    %w(Organización Unidad Id.unidad Unidad Total A1 A2 C1 C2 Agr X )
  end

end
