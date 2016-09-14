class AddPeriodIdToAssignedEmployees < ActiveRecord::Migration
  def change
  	add_column :assigned_employees, :period_id, :integer
  end
end
