class User < ActiveRecord::Base
  #has_many :organizations, through: :user_organizations
  has_one :administrator
  has_one :valuator
  has_one :manager
  has_many :user_organizations
  has_many :organizations, through: :user_organizations

  #accepts_nested_attributes_for :organization, update_only: true

  scope :administrator, -> { joins(:administrator) }
  scope :moderators,     -> { joins(:moderator) }
  scope :valuators,     -> { joins(:valuator) }

#  scope :by_document,    -> (document_type, document_number) { where(document_type: document_type, document_number: document_number) }

  def uweb_update!(uweb_data)
    if login == uweb_data[:login]
      self.uweb_id = uweb_data[:uweb_id]
      self.name = uweb_data[:name]
      self.surname = uweb_data[:surname]
      self.second_surname = uweb_data[:second_surname]
      self.document_number = uweb_data[:document]
      self.phone = uweb_data[:phone]
      self.email = uweb_data[:email]
      self.official_position = uweb_data[:official_position]
      self.pernr = uweb_data[:pernr]
      self.save
     else
       false
     end
  end

  def is_admin?
    administrator.present?
  end

  def is_valuator?
    valuator.present?
  end

  def is_manager?
    manager.present?
  end

  def full_name
    name + " " + surname + " " + second_surname
  end

  def has_organizations?
    auth_organizations.present? || ( is_admin? || is_manager?)
  end

  def organizations_unique?
    auth_organizations.size == 1
  end

  def auth_organizations
    @organizations ||=  ( is_admin? || is_manager? ) ? Organization.all : organizations
  end

end
