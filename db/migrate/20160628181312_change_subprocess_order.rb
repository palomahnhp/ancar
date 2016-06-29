class ChangeSubprocessOrder < ActiveRecord::Migration
  def change
    change_column :sub_processes, :order, :string
  end
end
