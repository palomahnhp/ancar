class RemoveInOutFromMetrics < ActiveRecord::Migration
  def change
  	remove_column :metrics, :in_out, :string
  end
end
