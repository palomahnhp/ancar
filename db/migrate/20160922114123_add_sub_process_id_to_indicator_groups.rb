# noinspection RubyClassModuleNamingConvention
class AddSubProcessIdToIndicatorGroups < ActiveRecord::Migration
  def change
  	add_column :indicator_groups, :sub_process_id, :integer
  end
end
