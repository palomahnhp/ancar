class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
    	t.string  :name
    	t.integer :order
    	t.boolean :has_specification
    	t.text    :specification
    	t.string  :updated_by

    	t.timestamps null: false
      t.timestamps null: false
    end
  end
end
