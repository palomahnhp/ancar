class ChangeEntryIndicators < ActiveRecord::Migration
 change_table :entry_indicators do |t|
    t.column :amount, :integer 
    t.column :total_process, :integer
    t.column :total_sub_process, :integer
  end

  change_table :indicators do |t|
      t.remove :out
      t.rename :in, :in_out  
      t.change :in_out, :string 
  end  
end
