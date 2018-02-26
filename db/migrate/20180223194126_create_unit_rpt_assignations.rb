class CreateUnitRptAssignations < ActiveRecord::Migration
  def change
    create_table :unit_rpt_assignations do |t|
      t.integer    :year
      t.belongs_to :organization
      t.belongs_to :unit
      t.integer    :sapid_unit
      t.string     :den_unit
    end
  end
end
