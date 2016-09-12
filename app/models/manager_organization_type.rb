class ManagerOrganizationType < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization_type
end
