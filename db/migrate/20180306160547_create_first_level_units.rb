class CreateFirstLevelUnits < ActiveRecord::Migration
  def change
    create_table :first_level_units do |t|
      t.integer    :sapid_unit
      t.string     :den_unit
      t.belongs_to :organization # Manager Organization
      t.integer    :period_from
      t.integer    :period_to

      t.timestamp
    end
  end
end
