class AddSummaryTypeToTotalIndicator < ActiveRecord::Migration
  def change
    add_reference :total_indicators, :summary_type, index: true, foreign_key: true
  end
end
