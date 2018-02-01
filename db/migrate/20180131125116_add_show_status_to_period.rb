class AddShowStatusToPeriod < ActiveRecord::Migration
  def change
    add_column :periods, :hide_status, :boolean, default: false
  end
end
