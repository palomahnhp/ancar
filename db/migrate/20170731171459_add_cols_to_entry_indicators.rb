class AddColsToEntryIndicators < ActiveRecord::Migration
  def change
    add_column :entry_indicators, :imported_amount, :integer
  end
end
