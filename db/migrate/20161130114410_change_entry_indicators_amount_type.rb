# noinspection RubyClassModuleNamingConvention
class ChangeEntryIndicatorsAmountType < ActiveRecord::Migration
  def change
    change_column :entry_indicators, :amount, :decimal, precision: 15, scale: 2
  end
end
