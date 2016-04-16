class Admin::OrganizationType < ActiveRecord::Base
  has_many :organizations
  has_many :periods
end
