class CreateSummaryProcesses < ActiveRecord::Migration
  def change
    create_table :summary_processes do |t|
      t.belongs_to :unit
      t.integer  :process_id
      t.string   :process_type
      t.decimal  :amount, :precision => 12, :scale => 2
      t.decimal  :A1, :precision => 5, :scale => 2
      t.decimal  :A2, :precision => 5, :scale => 2
      t.decimal  :C1, :precision => 5, :scale => 2
      t.decimal  :C2, :precision => 5, :scale => 2
      t.decimal  :E,  :precision => 5, :scale => 2
      t.string   :updated_by

      t.timestamps null: false
    end
  end
end
