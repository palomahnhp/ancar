class CreateOrganizationTypes < ActiveRecord::Migration
  def change
    create_table :organization_types do |t|
      t.string :acronym
      t.string :name
      t.string :updated_by

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
