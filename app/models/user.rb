class User < ActiveRecord::Base
  rolify
  belongs_to :organization
  validates :login, presence: true, uniqueness: true
#  validates :uweb_id, uniqueness: true
#  validates :pernr, uniqueness: true

  ROLES =%w[admin, validator, validator, validator, viewer]

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
    if organization_type_id != 0
      # global roles
      if self.has_any_role? :admin, :validator, :visitor
        @organizations ||= Organization.where(organization_type_id: organization_type_id).distinct
      # scoped roles
      else
         organization_type_roles = OrganizationType.applied_roles
         user_roles = self.roles
         if (organization_type_roles.ids).map{ |id| (user_roles.ids).include? id}
           @organizations ||= Organization.where(organization_type_id: organization_type_id)
         end
      end
    else
      @organizations ||= Organization.with_roles([:unit_user, :admin, :validator, :visitor], self).distinct
    end
  end

  def auth_organization_types
    # global roles
    if self.has_any_role? :admin, :validator, :visitor
      @organization_types ||= OrganizationType.all
    # scoped roles
    else
     @organization_types ||= OrganizationType.with_roles([:admin, :validator, :visitor], self)
    end
  end

  def organization_description
    self.organization.nil? ? '' : self.organization.description
  end

  def filter_roles(role)
    role.nil? ? self.roles :  self.roles.where(name: role)
  end
end
