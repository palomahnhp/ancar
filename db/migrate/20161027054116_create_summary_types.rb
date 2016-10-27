class CreateSummaryTypes < ActiveRecord::Migration
  def change
    create_table :summary_types do |t|
      t.belongs_to :item, index: true, foreign_key: true
      t.string     :acronym
      t.integer    :order

      t.string     :updated_by
      t.timestamps null: false
    end
  end
end
