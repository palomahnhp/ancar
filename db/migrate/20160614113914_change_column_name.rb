class ChangeColumnName < ActiveRecord::Migration
  def change
  	rename_column :total_indicators, :type, :indicator_type
  end
end
