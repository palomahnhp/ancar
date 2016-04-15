class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name
      t.integer :sap_id
      t.string :updated_by

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
