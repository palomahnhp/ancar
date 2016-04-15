class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :short_name
      t.string :sap_id
      t.string :updated_by

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
