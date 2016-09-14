class AddColsToIndicatorGroups < ActiveRecord::Migration
  def change
  	add_column :indicator_groups, :item_id, :integer
		add_column :indicator_groups, :order, :integer 
  end
end
