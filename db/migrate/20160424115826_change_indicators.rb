class ChangeIndicators < ActiveRecord::Migration
  def change
    rename_column :indicators, :type, :in_out
    add_column :indicators, :order, :integer
  end
end
