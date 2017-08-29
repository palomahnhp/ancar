class User < ActiveRecord::Base
  rolify
  paginates_per 25
  belongs_to :organization
  validates :login, presence: true, uniqueness: true,
            format: { with: /\A[a-zA-Z]{3}\d{3}\z/, message: "No es un código ayre válido, debe tener tres letras y tres números"}

#  validates :uweb_id, uniqueness: true
#  validates :pernr, uniqueness: true

  ROLES = [:interlocutor, :validator, :reader, :supervisor, :admin  ]

  default_scope  { order(:login)} #  Overriding default_scope: unscoped
  scope :active,         -> { where(inactivated_at: nil) }
  scope :inactive,       -> { where.not(inactivated_at: nil) }
  scope :has_role, lambda{|role| includes(:roles).where(:roles => { :name=> role })}

  def login=(val)
    self[:login] = val.upcase
  end

  def inactivate!(uweb_id)
    self.inactivated_at = Time.now
    if self.uweb_off!(uweb_id) && self.delete_roles
      return self.save
    end
    false
  end

  def activate!(uweb_id)
    self.inactivated_at =  nil
    if self.uweb_on!(uweb_id)
      return self.save
    end
    return false
  end

  def page(per_page = 25)
    position = User.where("login <= ?", self.login).count
    (position.to_f/per_page).ceil
  end

  def uweb_update
    uweb_data = UwebApi.new(login: self.login).get_user
    if uweb_data.present? && login == uweb_data[:login] && uweb_data[:active]
      self.uweb_id = uweb_data[:uweb_id]
      self.phone = uweb_data[:phone]
      self.email = uweb_data[:email]
      self.pernr = uweb_data[:pernr]
      # Se incluyen datos basicos que en el caso de los empleados serán sobreescritos pro datos de Directorio
      self.name = uweb_data[:name]
      self.surname = uweb_data[:surname]
      self.second_surname = uweb_data[:second_surname]
      self.sap_den_unit = uweb_data[:unidad]
      self.official_position = uweb_data[:official_position]
    else
      false
    end
  end

  def uweb_update!
    if self.uweb_update
      self.save
    else
      false
    end
  end

  def uweb_on!(uweb_id)
    if UwebUpdateApi.new(uweb_id).insert_profile(self)
       self.uweb_auth_at = Time.now
       return true
    end
    false
  end

  def uweb_off!(uweb_id)
    if UwebUpdateApi.new(uweb_id).remove_profile(self)
       self.uweb_auth_at = nil
       return true
    end
    false
  end

  def uweb?
    # tiene  acceso?
  end

  def directory_update
    data  = DirectoryApi.new.employees_data(pernr: self.pernr)

    user_data = data['EMPLEADOS_ACTIVOS']['EMPLEADO'] if data['EMPLEADOS_ACTIVOS'].present?
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
    else
      false
    end
  end

  def directory_update!
    if self.directory_update
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

  def active?
    inactivated_at.nil? ? true : false
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

  def auth_units()
    @units = self.auth_organizations.map { |o| o.units }
  end

  def auth_organization_types_unique?
    auth_organization_types.size == 1
  end

  def auth_organization_types
    # global roles
    if self.has_any_role? :admin, :supervisor, :reader, :validator, :interlocutor
      @organization_types ||= OrganizationType.all
      # scoped roles
    else
      @organization_types ||= OrganizationType.with_roles(ROLES, self)
    end
    return @organization_types
  end

  def auth_organization_types_ids
    # global roles
    if self.has_any_role? :admin, :supervisor, :reader, :validator, :interlocutor
      @organization_types ||= OrganizationType.all
    # scoped roles
    else
     @organization_types ||= OrganizationType.with_roles(ROLES, self).ids + Organization.with_roles(ROLES, self).map { |o| o.organization_type.id}
    end
    return @organization_types
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

  def has_role(role)

  end

  def delete_roles
     self.roles = []
     self.roles
  end

  def self.roles_select_options(class_name =  '' )
    roles = ROLES.map.with_index { |r, i| [  I18n.t("admin.users.roles.role.name.#{r.to_s}"), i ] }.to_h
    if class_name == Organization
     roles.delete(I18n.t("admin.users.roles.role.name.#{:admin.to_s}"))
     roles.delete(I18n.t("admin.users.roles.role.name.#{:supervisor.to_s}"))
    elsif class_name == OrganizationType
      roles.delete(I18n.t("admin.users.roles.role.name.#{:interlocutor.to_s}"))
      roles.delete(I18n.t("admin.users.roles.role.name.#{:validator.to_s}"))
    end
    return roles
  end

end
