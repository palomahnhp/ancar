class CreateIndicatorSources < ActiveRecord::Migration
  def change
    create_table :indicator_sources do |t|
      t.boolean :fixed
      t.timestamps null: false
    end
  end
end
