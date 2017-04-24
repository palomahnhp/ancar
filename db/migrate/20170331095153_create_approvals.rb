class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.integer :subject_id
      t.string :subject_type
      t.string :approved_by
      t.date :approved_at
      t.text :comments
    end
  end
end
