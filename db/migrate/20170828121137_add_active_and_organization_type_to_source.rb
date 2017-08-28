class AddActiveAndOrganizationTypeToSource < ActiveRecord::Migration
  change_table :sources do |t|
    t.belongs_to :organization_type, index: true, foreign_key: true
    t.boolean  :active, default: true
  end
end
