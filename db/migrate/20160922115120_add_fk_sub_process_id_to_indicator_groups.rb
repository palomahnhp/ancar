# noinspection RubyClassModuleNamingConvention
class AddFkSubProcessIdToIndicatorGroups < ActiveRecord::Migration
  def change
  	add_foreign_key :indicator_groups, :sub_processes, index: true
  end
end
