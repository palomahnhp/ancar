class CreateTypeOrganizations < ActiveRecord::Migration
  def change
    create_table :type_organizations do |t|
    	t.string :acronym
    	t.string :name
    	t.string :updated_by

    	t.timestamps null: false
      t.timestamps null: false
    end
  end
end
