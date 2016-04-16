class CreateMainProcesses < ActiveRecord::Migration
  def change
    create_table :main_processes do |t|
      t.integer :order
      t.string :description
      t.string :updated_by

      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
