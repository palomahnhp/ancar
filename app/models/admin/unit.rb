class Admin::Unit < ActiveRecord::Base
  belongs_to :unit_type
  belongs_to :organization
end
