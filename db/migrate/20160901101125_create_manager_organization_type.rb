class CreateManagerOrganizationType < ActiveRecord::Migration
  def change
    create_table :manager_organization_types do |t|
      t.references :user, index: true, foreign_key: true
      t.references :organization_type, index: true, foreign_key: true
    end
  end
end
