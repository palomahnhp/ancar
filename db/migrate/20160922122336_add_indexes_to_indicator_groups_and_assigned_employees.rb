# noinspection RubyClassModuleNamingConvention
class AddIndexesToIndicatorGroupsAndAssignedEmployees < ActiveRecord::Migration
  def change
  	add_index :indicator_groups, :sub_process_id
  	add_index :indicator_groups, :item_id
  	add_index :assigned_employees, :period_id
  end
end
