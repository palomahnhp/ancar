class AddActiveToSummaryTypes < ActiveRecord::Migration
  def change
    add_column :summary_types, :active,:boolean
  end
end
