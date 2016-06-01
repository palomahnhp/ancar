class CreateIndicatorMetrics < ActiveRecord::Migration
  def change
    create_table :indicator_metrics do |t|
      t.belongs_to :indicator, index:true
      t.belongs_to :metric, index:true
      t.integer :total_process
      t.integer :total_sub_process
    end

    change_table :indicators do |t|
      t.remove :in_out
      t.remove :total_process
      t.remove :total_sub_process
      t.remove :metric_id
    end

    change_table :metrics do |t|
      t.string :in_out
    end

    change_table :entry_indicators do |t|
      t.remove :indicator_id
      t.belongs_to :indicator_metric, index:true
      t.remove  :amount
      t.decimal :amount, :precision => 12, :scale => 2
    end  end
end
