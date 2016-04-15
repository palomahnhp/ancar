class CreateIndicatorSources < ActiveRecord::Migration
  def change
    create_table :indicator_sources do |t|
    	t.belongs_to :indicator, index: true, foreign_key: true
    	t.belongs_to :source, index: true, foreign_key: true
    	t.string :updated_by 
      
      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
