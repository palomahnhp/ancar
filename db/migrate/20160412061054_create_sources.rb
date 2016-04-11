class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
    	t.string :description
    	t.text :specification

      t.timestamps null: false
    end
  end
end
