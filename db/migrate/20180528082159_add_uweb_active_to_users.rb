class AddUwebActiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uweb_active, :boolean
  end
end
