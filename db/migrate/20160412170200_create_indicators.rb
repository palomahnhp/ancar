class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
    	t.belongs_to :task, index: true, foreign_key: true
    	t.integer :order
      t.string :description
      t.integer :amount_in      
      t.integer :amount_out
      t.string :fixed_source  
      t.string :updated_by 
      
      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
