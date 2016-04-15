class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
    	t.string :name, limit: 80
    	t.string :description, limit: 100
    	t.date :initial_date 
    	t.date :final_date 
    	t.boolean :closed 
    	t.string  :updated_by

    	t.timestamps null: false
      t.timestamps null: false
    end
  end
end
