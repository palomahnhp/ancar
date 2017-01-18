class AddInactivatedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :inactivated_at, :datetime
  end
end
