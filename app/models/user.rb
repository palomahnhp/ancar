class User < ActiveRecord::Base
  include Updatable
  include Authorizable
  include Trackable

  rolify
  paginates_per 25
  belongs_to :organization
  validates :login, presence: true, uniqueness: true,
            format: { with: /\A[a-zA-Z]{3}\d{3}\z/,
            message: "No es un código ayre válido, debe tener tres letras y tres números"}

  ROLES = [:interlocutor, :validator, :reader, :supervisor, :admin  ]

  default_scope  { order(:surname, :second_surname, :name)} #  Overriding default_scope: unscoped
  scope :active,   -> { where(inactivated_at: nil) }
  scope :inactive, -> { where.not(inactivated_at: nil) }
  scope :has_role, lambda{|role| includes(:roles).where(:roles => { :name=> role })}

  def login=(val)
    self[:login] = val.upcase
  end

  def full_name
    self.name + ' ' + self.surname + ' ' + self.second_surname
  end

  def surname_name
     self.surname + ' ' + self.second_surname + ', ' + self.name
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

  def assign_organization(unit_data)

    assignation = UnitRptAssignation.find_by(sapid_unit: unit_data['ID_UNIDAD'])
    return true if assignation.blank?
    organization = Organization.find_by(id: assignation.organization_id)
    self.sap_id_organization = organization.sap_id
    self.sap_den_organization = organization.description
  end

  def change_status
    inactivated_at.nil? ? I18n.t('shared.users.edit.button.inactivate') : I18n.t('shared.users.edit.button.activate')
  end

  def organization_description
    self.organization.nil? ? '' : self.organization.description
  end

  def self.export_columns
    %w(login surname_name official_position sap_den_unit sap_den_organization
       email phone created_at roles_description uweb_auth_at inactivated_at )
  end

  def position_or_inactive
    return official_position if uweb_active.present?
    'Baja en ayre'
  end
  
  def self.ransackable_attributes(_auth_object = nil)
    %w[login fullname] + _ransackers.keys
  end

  def self.auth(current_user)
    return User.all if current_user.has_role? :admin
    sap_ids = current_user.auth_organizations(OrganizationType.with_roles(ROLES, current_user).ids).map { |o| o.sap_id }
    User.where(sap_id_organization: sap_ids)
  end

  def self.roles_select_options(class_name =  '' )
    roles = ROLES.map.with_index { |r, i| [  I18n.t("shared.users.roles.role.name.#{r.to_s}"), i ] }.to_h
    if class_name == Organization
      roles.delete(I18n.t("shared.users.roles.role.name.#{:admin.to_s}"))
      roles.delete(I18n.t("shared.users.roles.role.name.#{:supervisor.to_s}"))
      roles.delete(I18n.t("shared.users.roles.role.name.#{:reader.to_s}"))
    elsif class_name == OrganizationType
      roles.delete(I18n.t("shared.users.roles.role.name.#{:admin.to_s}"))
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

end
