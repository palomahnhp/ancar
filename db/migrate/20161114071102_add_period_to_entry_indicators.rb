class AddPeriodToEntryIndicators < ActiveRecord::Migration
  def change
    add_reference :entry_indicators, :period, index: true, foreign_key: true
  end
end
