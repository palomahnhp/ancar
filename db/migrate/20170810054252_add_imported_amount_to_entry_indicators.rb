class AddImportedAmountToEntryIndicators < ActiveRecord::Migration
  def change
    add_column :entry_indicators, :imported_amount, :decimal, precision: 15, scale: 2
  end
end
