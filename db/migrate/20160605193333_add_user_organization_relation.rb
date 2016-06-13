class AddUserOrganizationRelation < ActiveRecord::Migration
  def change
    create_table :user_organizations do |t|
      t.belongs_to :user_id, index: true
      t.belongs_to :organization_id, index: true
    end
  end
end
