class CreateSubprocesses < ActiveRecord::Migration
  def change
    create_table :subprocesses do |t|
      t.integer :orden
      t.string :descripcion

      t.timestamps null: false
    end
  end
end
