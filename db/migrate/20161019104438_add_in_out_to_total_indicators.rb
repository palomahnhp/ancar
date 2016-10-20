class AddInOutToTotalIndicators < ActiveRecord::Migration
  def change
  	add_column :total_indicators, :in_out, :string
  	add_index :total_indicators, :in_out
  end
end
