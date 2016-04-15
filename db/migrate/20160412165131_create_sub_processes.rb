class CreateSubProcesses < ActiveRecord::Migration
  def change
    create_table :sub_processes do |t|
    	t.belongs_to :main_process, index: true, foreign_key: true
    	t.integer :order
    	t.string :description
      t.string :updated_by 

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
