class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
    	t.belongs_to :task, index: true, foreign_key: true
      t.string :indicator_int
      t.belongs_to :source ,index: true, foreign_key: true
      t.integer :amount 
      
      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
