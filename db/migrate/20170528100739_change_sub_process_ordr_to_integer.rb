class ChangeSubProcessOrdrToInteger < ActiveRecord::Migration
  def change
    rename_column :sub_processes, :order, :order_char
    add_column :sub_processes, :order, :integer
  end
end
