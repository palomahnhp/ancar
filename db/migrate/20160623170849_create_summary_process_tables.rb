class CreateSummaryProcessTables < ActiveRecord::Migration
  def change
    create_table :summary_processes do |t|
      t.integer :process_id
      t.string  :process_type
      t.string :process_description
      t.belongs_to :period

      t.string :updated_by
      t.timestamps null: false
    end

    create_table :summary_process_indicators do |t|
      t.belongs_to :summary_process, index: true, foreign_key: true
      t.string :indicator
      t.string :metric

      t.string :updated_by
      t.timestamps null: false
    end

    create_table :summary_process_details do |t|
      t.belongs_to :summary_process, index: true, foreign_key: true
      t.belongs_to :unit, index: true, foreign_key: true
      t.belongs_to :sub_process, index: true, foreign_key: true
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
