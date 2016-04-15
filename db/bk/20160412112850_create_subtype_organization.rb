class CreateSubtypeOrganization < ActiveRecord::Migration
  def change
    create_table :subtype_organizations do |t|
    	t.belongs_to :type_organization, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
