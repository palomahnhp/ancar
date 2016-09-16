class User < ActiveRecord::Base
  #has_many :organizations, through: :user_organizations
  has_one :administrator
  has_one :valuator
  has_one :manager
  has_many :user_organizations
  has_many :manager_organization_types
  has_many :organizations, through: :user_organizations

  validates :login, presence: true, uniqueness: true
  validates :uweb_id, uniqueness: true
  validates :pernr, uniqueness: true

  enum role: [:user, :validator, :manager, :admin]

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

  def full_name
    name + " " + surname + " " + second_surname
  end

  def has_organizations?
    auth_organizations.present?
  end

  def organizations_unique?
    auth_organizations.size == 1
  end

  def has_organization_types?
    auth_organization_types.present?
  end

  def auth_organizations(organization_type_id: 0)
    if organization_type_id != 0
      @organizations ||= Organization.where(organization_type_id: organization_type_id)
    elsif has_organization_types?
      @organizations ||= Organization.where(organization_type_id: @organization_types.ids)
    else
      @organizations ||= ( self.admin?) ? Organization.all : organizations
    end
  end

  def auth_organization_types
    if self.admin?
      @organization_types ||= OrganizationType.all
    elsif self.manager?
      @organization_types ||= OrganizationType.where(id: ManagerOrganizationType.where(user_id: id).pluck(:organization_type_id))
    end
  end
end
