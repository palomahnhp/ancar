class User < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  rolify
  paginates_per 25
  belongs_to :organization
  validates :login, presence: true, uniqueness: true,
            format: { with: /\A[a-zA-Z]{3}\d{3}\z/,
            message: "No es un código ayre válido, debe tener tres letras y tres números"}

  ROLES = [:interlocutor, :validator, :reader, :supervisor, :admin  ]

  default_scope  { order(:login)} #  Overriding default_scope: unscoped
  scope :active,   -> { where(inactivated_at: nil) }
  scope :inactive, -> { where.not(inactivated_at: nil) }
  scope :has_role, lambda{|role| includes(:roles).where(:roles => { :name=> role })}

  def login=(val)
    self[:login] = val.upcase
  end

  def full_name
    "#{self.name} #{self.surname} #{self.second_surname}"
  end

  def status
    inactivated_at.nil? ? I18n.t('shared.users.status.active') : I18n.t('shared.users.status.inactive')
  end

  def active?
    inactivated_at.nil? ? true : false
  end

  def inactivate!(uweb_id)
    self.inactivated_at = Time.now
    return self.save if self.uweb_off!(uweb_id) && self.delete_roles
    false
  end

  def activate!(uweb_id)
    self.inactivated_at =  nil
    return self.save if self.uweb_on!(uweb_id)
    false
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
#     Datos básicos para personal externo, que en el caso de empleados se sobreescribiran con datos de Directorio
      self.name = uweb_data[:name]
      self.surname = uweb_data[:surname]
      self.second_surname = uweb_data[:second_surname]
      self.sap_den_unit = uweb_data[:unit]
      self.official_position = uweb_data[:official_position]
      true
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
       self.save
       return true
    end
    false
  end

  def uweb_off!(uweb_id)
    if UwebUpdateApi.new(uweb_id).remove_profile(self)
       self.uweb_auth_at = nil
       self.save
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
      self.document_number    = user_data['NIF']
      self.name               = fix_encoding(user_data['NOMBRE'])
      self.surname            = fix_encoding(user_data['APELLIDO1'])
      self.second_surname     = fix_encoding(user_data['APELLIDO2'])
      self.document_number    = user_data['NIF']
      self.official_position  = fix_encoding(user_data['DENOMINACION_PUESTO'])
      self.sap_den_unit       = fix_encoding(user_data['DEN_UNIDAD_FUNCIONAL'])
      self.sap_id_unit        = user_data['ID_UNIDAD_FUNCIONAL']

      data  = DirectoryApi.new.get_unit_data(self.sap_id_unit)
      unit_data = data['UNIDAD_ORGANIZATIVA']
      if unit_data.present?
        self.assign_organization(unit_data)
#        self.sap_id_organization  = unit_data['AREA']
#        self.sap_den_organization = fix_encoding(unit_data['DENOM_AREA'])
      end
    else
      false
    end
  end

  def assign_organization(unit_data)

    assignation = UnitRptAssignation.find_by(sapid_unit: unit_data['ID_UNIDAD'])
    return true if assignation.blank?
    organization = Organization.find_by(id: assignation.organization_id)
    self.sap_id_organization = organization.sap_id
    self.sap_den_organization = organization.description
  end

  def directory_update!
    if self.directory_update
      self.save
    else
      false
    end
  end

  def change_status
    inactivated_at.nil? ? I18n.t('shared.users.edit.button.inactivate') : I18n.t('shared.users.edit.button.activate')
  end

  def has_organizations?(organization_type_ids = [])
    auth_organizations(organization_type_ids).present?
  end

  def organizations_unique?
    auth_organizations.size == 1
  end

  def has_organization_types?
    auth_organization_types.present?
  end

  def auth_organizations(organization_type_ids = [])
    if self.has_any_role? :admin
      @organizations ||= Organization.all.distinct
    elsif organization_type_ids.present?
      # global roles
      if self.has_any_role? :supervisor, :reader, :validator, :interlocutor
        @organizations ||= Organization.where(organization_type_id: organization_type_ids).distinct
      # scoped roles
      else
         organization_type_roles = OrganizationType.applied_roles
         user_roles = self.roles
         if (organization_type_roles.ids).map{ |id| (user_roles.ids).include? id}
           @organizations ||= Organization.where(organization_type_id: organization_type_ids)
         end
      end
    else
      @organizations ||= Organization.with_roles(ROLES, self).distinct
    end
    @organizations = @organizations.distinct.order(:description)
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
    @organization_types
  end

  def auth_organization_types_ids
    # global roles
    if self.has_any_role? :admin, :supervisor, :reader, :validator, :interlocutor
      @organization_types ||= OrganizationType.all
    # scoped roles
    else
     @organization_types ||= OrganizationType.with_roles(ROLES, self).ids + Organization.with_roles(ROLES, self).map { |o| o.organization_type.id}
    end
    @organization_types
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
    roles = ROLES.map.with_index { |r, i| [  I18n.t("shared.users.roles.role.name.#{r.to_s}"), i ] }.to_h
    if class_name == Organization
      roles.delete(I18n.t("shared.users.roles.role.name.#{:shared.to_s}"))
      roles.delete(I18n.t("shared.users.roles.role.name.#{:supervisor.to_s}"))
    elsif class_name == OrganizationType
      roles.delete(I18n.t("shared.users.roles.role.name.#{:shared.to_s}"))
      roles.delete(I18n.t("shared.users.roles.role.name.#{:interlocutor.to_s}"))
      roles.delete(I18n.t("shared.users.roles.role.name.#{:validator.to_s}"))
    else
      roles.delete(I18n.t("shared.users.roles.role.name.#{:interlocutor.to_s}"))
      roles.delete(I18n.t("shared.users.roles.role.name.#{:validator.to_s}"))
      roles.delete(I18n.t("shared.users.roles.role.name.#{:supervisor.to_s}"))
      roles.delete(I18n.t("shared.users.roles.role.name.#{:reader.to_s}"))
    end
    roles
  end

  def self.auth(current_user)
     return User.all if current_user.has_role? :admin
     sap_ids = current_user.auth_organizations(OrganizationType.with_roles(ROLES, current_user).ids).map { |o| o.sap_id }
     User.where(sap_id_organization: sap_ids)
  end

  def has_auth?(current_user)
    return true if current_user.has_role? :admin
    sap_ids = current_user.auth_organizations(OrganizationType.with_roles(ROLES, current_user).ids).map { |o| o.sap_id }
    User.where(id: id, sap_id_organization: sap_ids)
  end

  def self.export_columns
    %w(login full_name official_position sap_den_unit sap_den_organization
       email phone created_at roles_description uweb_auth_at inactivated_at )
  end

  def roles_description
    roles_description = ''
    a = roles.map { |role| "#{roles_description} #{I18n.t("shared.roles.role.name.#{role.name}")}"}

    return a.uniq[0].strip unless a.empty?
    ""
  end

end
