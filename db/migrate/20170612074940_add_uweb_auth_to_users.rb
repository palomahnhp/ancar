class AddUwebAuthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uweb_auth_at, :date
  end
end
