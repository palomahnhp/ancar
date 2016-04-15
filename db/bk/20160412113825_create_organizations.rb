class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
    	t.belongs_to :main_organization, index: true, foreign_key: true
    	t.belongs_to :subtype_organization, index: true, foreign_key: true
    	t.string :name
    	t.string :sap_id
    	t.string :updated_by

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
