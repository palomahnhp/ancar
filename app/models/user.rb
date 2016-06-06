class User < ActiveRecord::Base
  #has_many :organizations, through: :user_organizations
  has_one :administrator
  has_one :valuator
  has_one :manager

  #accepts_nested_attributes_for :organization, update_only: true

  scope :administrators, -> { joins(:administrator) }
  scope :moderators,     -> { joins(:moderator) }
  scope :valuators,     -> { joins(:valuator) }
#  scope :organizations,  -> { joins(:organization) }
#  scope :by_document,    -> (document_type, document_number) { where(document_type: document_type, document_number: document_number) }

  def administrator?
    administrator.present?
  end

  def valuator?
    valuator.present?
  end

  def manager?
    manager.present?
  end

  def organization?
#    organization.present?
  end
end
