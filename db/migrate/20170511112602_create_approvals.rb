class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.belongs_to :period, index: true, foreign_key: true
      t.belongs_to :unit, index: true, foreign_key: true
      t.text   :comment
      t.string :approval_by
      t.date   :approval_at

      t.timestamps null: false
    end
  end
end
