class AddFkItemsToIndicatorGroups < ActiveRecord::Migration
  def change
  	add_foreign_key :indicator_groups, :items
  end
end
