class AddOrganizationTypeToDocs < ActiveRecord::Migration
  def change
    add_reference :docs, :organization_type, index: true, foreign_key: true
  end
end
