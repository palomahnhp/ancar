class AddEmailedAtToAssignedEmployeesChanges < ActiveRecord::Migration
  def change
    add_column :assigned_employees_changes, :emailed_at , :timestamp
  end
end
