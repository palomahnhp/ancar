class ChangeIndicatorGroups < ActiveRecord::Migration
  def change
  	add_reference :indicator_groups, :main_processes, index: true
		add_reference :indicator_groups, :items, index: true
		add_column :indicator_groups, :order, :integer 
		remove_column :indicator_groups, :description, :string
  end
end
