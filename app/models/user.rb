class User < ActiveRecord::Base
  rolify
  belongs_to :organization
  validates :login, presence: true, uniqueness: true
#  validates :uweb_id, uniqueness: true
#  validates :pernr, uniqueness: true

  ROLES = [:admin, :supervisor, :reader, :validator, :interlocutor]

  default_scope  { order(:login)} #  Overriding default_scope: unscoped
  scope :active,         -> { where(inactivated_at: nil) }
  scope :inactive,       -> { where.not(inactivated_at: nil) }

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
    name = self.name.nil? ? '' : self.name
    surname = self.surname.nil? ? '' : self.surname
    second_surname = self.second_surname.nil? ? '' : self.second_surname

    name + ' ' + surname + ' ' + second_surname
  end

  def status
    inactivated_at.nil? ? I18n.t('admin.users.status.active') : I18n.t('admin.users.status.inactive')
  end

  def change_status
    inactivated_at.nil? ? I18n.t('admin.users.edit.button.inactivate') : I18n.t('admin.users.edit.button.activate')
  end

  def has_organizations?(organization_type_id = 0)
    a = auth_organizations(organization_type_id)
    a.present?
  end

  def organizations_unique?
    auth_organizations.size == 1
  end

  def has_organization_types?
    auth_organization_types.present?
  end

  def auth_organizations(organization_type_id = 0)
    if organization_type_id.present?
      organizations = auth_organization_by_organization_type(organization_type_id)
    else
      organizations = Organization.with_roles(ROLES, self).distinct
    end
    return organizations
  end

  def auth_organization_types_organizations(organization_types)
    organizations = []
    organization_types.each do |organization_type|
      auth_organization_by_organization_type(organization_type.id).map{|organization| organizations << organization}
    end
    return organizations
  end

  def auth_organization_types
    # global roles
    if self.has_any_role? :admin, :supervisor, :reader, :validator, :interlocutor
      organization_types = OrganizationType.all
    # scoped roles
    else
      organization_types = OrganizationType.with_roles(ROLES, self)
    end
    return organization_types
  end

  def organization_description
    self.organization.nil? ? '' : self.organization.description
  end

  def filter_roles(role)
    role.nil? ? self.roles :  self.roles.where(name: role)
  end

  private
  def auth_organization_by_organization_type(organization_type_id)
    # global roles
    if self.has_any_role? :admin, :supervisor, :reader
      return Organization.where(organization_type_id: organization_type_id).distinct
    else # scoped roles
      organization_type_roles = OrganizationType.applied_roles
      user_roles = self.roles
      if (organization_type_roles.ids).map{ |id| (user_roles.ids).include? id}
        return Organization.where(organization_type_id: organization_type_id)
      end
    end
  end
end
