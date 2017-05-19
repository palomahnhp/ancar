class AddOfficialPositionToApprovals < ActiveRecord::Migration
  change_table :approvals do |t|
    t.string :official_position
  end
end
