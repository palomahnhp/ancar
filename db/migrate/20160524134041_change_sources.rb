class ChangeSources < ActiveRecord::Migration
  def change
    change_table :sources do |t|
      t.remove :indicator_id
    end
  end
end
