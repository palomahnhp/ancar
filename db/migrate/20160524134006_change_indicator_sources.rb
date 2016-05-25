class ChangeIndicatorSources < ActiveRecord::Migration
  def change
     rename_table :indicators_sources, :indicator_sources
  end
end
