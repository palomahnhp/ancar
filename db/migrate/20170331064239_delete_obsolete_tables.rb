class DeleteObsoleteTables < ActiveRecord::Migration
  def change
    drop_table :manager_organization_types
    drop_table :entry_indicator_sources
    drop_table :tmp_ind_e_s_import
    drop_table :user_organizations
  end
end
