class ChangeIndicators < ActiveRecord::Migration
  def change
    change_table :indicators do |t|
      t.remove :out
      t.rename :in, :in_out
      t.change :in_out, :string
      t.remove :metric
      t.column :metric, :integer
      t.column :total_process, :integer
      t.column :total_sub_process, :integer
    end
  end
end
