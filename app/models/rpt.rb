class Rpt < ActiveRecord::Base
  belongs_to :organization
  belongs_to :unit

  scope :by_organization, ->(organization) { where( organization: organization ) }
  scope :by_unit,         ->(unit) { where( unit: unit ) }
  scope :by_year,         ->(year) { where( year: year ) }

end