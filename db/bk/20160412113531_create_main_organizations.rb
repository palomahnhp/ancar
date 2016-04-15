class CreateMainOrganizations < ActiveRecord::Migration
  def change
    create_table :main_organizations do |t|
      t.belongs_to :type_organization, index: true, foreign_key: true
    	t.string :name
    	t.string :short_name
      t.string :sap_id
      t.string :updated_by 

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
