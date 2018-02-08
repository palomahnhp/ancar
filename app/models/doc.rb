class Doc  < ActiveRecord::Base
  belongs_to :organization_type

  validates_presence_of :name, :url
  validates_inclusion_of :format, in: %w[PDF JPG PNG HTML]

  scope :for_all, -> { where(organization_type_id: nil) }
  scope :auth, ->(user) { where(organization_type_id: user.auth_organization_types_ids) }

  def self.to_show(user)
    for_all + auth(user)
  end
end