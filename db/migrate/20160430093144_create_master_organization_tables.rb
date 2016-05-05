class CreateMasterOrganizationTables < ActiveRecord::Migration
  def change
    create_table :organization_types do |t|
      t.string :acronym
      t.string :description
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :organizations do |t|
      t.belongs_to :organization_type
      t.string :description
      t.string :short_description
      t.string :sap_id
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :unit_types do |t|
      t.belongs_to :organization_type
      t.string :description
      t.string :updated_by

      t.timestamps null: false
    end

    create_table :units do |t|
      t.belongs_to :unit_type
      t.belongs_to :organization
      t.string :description_sap
      t.integer :sap_id
      t.string :updated_by

      t.timestamps null: false
    end
  end
end
