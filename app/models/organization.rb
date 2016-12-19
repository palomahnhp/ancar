class Organization < ActiveRecord::Base
  resourcify
  belongs_to :organization_type
  has_many :units
  has_many :users, through: :user_organizations
end
