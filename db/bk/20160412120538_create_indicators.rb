class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
    	t.belongs_to :task, index: true, foreign_key: true
      t.string :indicator_in
      t.string :indicator_out      
      t.integer :amount 
      t.string :updated_by 
      
      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
