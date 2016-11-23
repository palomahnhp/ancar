class AddDescriptionToIndicators < ActiveRecord::Migration
  def change
    add_column :indicators, :description, :text
  end
end
