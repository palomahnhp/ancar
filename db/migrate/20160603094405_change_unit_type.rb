class ChangeUnitType < ActiveRecord::Migration
  def change
   change_table :unit_types do |t|
     t.integer :order
   end

   change_table :units do |t|
     t.integer :order
   end

   change_table :total_indicators do |t|
    t.remove :sub_process_group_id
    t.belongs_to :indicator_group
   end
  end
end
