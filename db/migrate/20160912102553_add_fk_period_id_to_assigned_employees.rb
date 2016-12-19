# noinspection RubyClassModuleNamingConvention
class AddFkPeriodIdToAssignedEmployees < ActiveRecord::Migration
  def change
  	add_foreign_key :assigned_employees, :periods
  end
end
