class Admin::Period < ActiveRecord::Base
  has_many :main_process
  belongs_to :organization_type
end
