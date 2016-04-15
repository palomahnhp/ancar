class CreateUnitTypes < ActiveRecord::Migration
  def change
    create_table :unit_types do |t|
      t.string :name

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
