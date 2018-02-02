class Validation  < ActiveRecord::Base

  belongs_to :period
  belongs_to :unit

  serialize :data_errors, Array

  scope :by_period, ->  (period_id) { where(period_id: period_id) }
  scope :by_unit,   ->  (unit_id)   { where(unit_id: unit_id) }
  scope :by_key,   ->  (key)   { where(key: key) }

  VALIDATION_TYPES = [ :entry_incomplete, :entry_without_staff, :assigned_staff,
                       :errors_in_out_stock, :global, :incomplete_staff_entry,
                       :incomplete_staff_unit, :no_change_staff, :no_justification ]
  def self.add(period, unit, key, title, message, data_errors)
    v = Validation.new()
    v.period  = period
    v.unit    = unit
    v.key     = key
    v.title   = title
    v.message = message
    v.data_errors  = data_errors if data_errors.present?


    v.save
  end
end