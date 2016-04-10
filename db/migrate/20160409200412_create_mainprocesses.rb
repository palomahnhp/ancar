class CreateMainprocesses < ActiveRecord::Migration
  def change
    create_table :mainprocesses do |t|
      t.integer :orden
      t.string :descripcion

      t.timestamps null: false
    end
  end
end
