class AddColsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sap_id_unit, :integer
    add_column :users, :sap_den_unit, :string
    add_column :users, :sap_id_organization, :integer
    add_column :users, :sap_den_organization, :string
    remove_column :users, :roles
  end
end
