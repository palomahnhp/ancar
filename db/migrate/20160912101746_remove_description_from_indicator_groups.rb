# noinspection RubyClassModuleNamingConvention
class RemoveDescriptionFromIndicatorGroups < ActiveRecord::Migration
  def change
  	remove_column :indicator_groups, :description, :string
  end
end
