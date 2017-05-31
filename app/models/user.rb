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

  def uweb_update!()
    uweb_data = UwebApi.new(login: self.login).get_user

    if uweb_data.present? && login == uweb_data[:login]
      self.uweb_id = uweb_data[:uweb_id]
      self.phone = uweb_data[:phone]
      self.email = uweb_data[:email]
      self.pernr = uweb_data[:pernr]
      self.save
     else
       false
     end
  end

  def directory_update!()
    data  = DirectoryApi.new.employees_data(pernr: self.pernr)

    user_data = data['EMPLEADOS_ACTIVOS']['EMPLEADO']
    if user_data.present?
      self.document_number = user_data['NIF']
      self.name = fix_encoding(user_data['NOMBRE'])
      self.surname = fix_encoding(user_data['APELLIDO1'])
      self.second_surname = fix_encoding(user_data['APELLIDO2'])
      self.document_number = user_data['NIF']
      self.official_position = fix_encoding(user_data['DENOMINACION_PUESTO'])
      self.sap_den_unit = fix_encoding(user_data['DEN_UNIDAD_FUNCIONAL'])
      self.sap_id_unit = user_data['ID_UNIDAD_FUNCIONAL']

      data  = DirectoryApi.new.get_unit_data(self.sap_id_unit)
      unit_data = data['UNIDAD_ORGANIZATIVA']
      if unit_data.present?
        self.sap_id_organization = unit_data['AREA']
        self.sap_den_organization = fix_encoding(unit_data['DENOM_AREA'])
      end
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
      if self.has_any_role? :admin, :supervisor, :reader, :validator, :interlocutor
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
      @organizations ||= Organization.with_roles(ROLES, self).distinct
    end
  end

  def auth_organization_types
    # global roles
    if self.has_any_role? :admin, :supervisor, :reader, :validator, :interlocutor
      @organization_types ||= OrganizationType.all
    # scoped roles
    else
     @organization_types ||= OrganizationType.with_roles(ROLES, self)
    end
  end

  def organization_description
    self.organization.nil? ? '' : self.organization.description
  end

  def filter_roles(role)
    role.nil? ? self.roles :  self.roles.where(name: role)
  end

  def fix_encoding(element)
    element.encode('ISO-8859-1').force_encoding("utf-8")
  end
end
