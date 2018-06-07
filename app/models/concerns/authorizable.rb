module Authorizable
  extend ActiveSupport::Concern

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
    if organization_type_ids.present?
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
    elsif self.has_any_role? :admin
      @organizations ||= Organization.all.distinct
    else
      @organizations ||= Organization.with_roles(User::ROLES, self).distinct
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
      @organization_types ||= OrganizationType.with_roles(User::ROLES, self)
    end
    @organization_types
  end

  def auth_organization_types_ids
    # global roles
    if self.has_any_role? :admin, :supervisor, :reader, :validator, :interlocutor
      @organization_types_ids ||= OrganizationType.all.ids
      # scoped roles
    else
      @organization_types_ids ||= OrganizationType.with_roles(User::ROLES, self).ids + Organization.with_roles(User::ROLES, self).map { |o| o.organization_type.id}
    end
    @organization_types_ids
  end

  def has_auth?(current_user)
    return true if current_user.has_role? :admin
    sap_ids = current_user.auth_organizations(OrganizationType.with_roles(User::ROLES, current_user).ids).map { |o| o.sap_id }
    User.where(id: id, sap_id_organization: sap_ids)
  end

  def roles_description
    roles_description = ''
    a = roles.map { |role| "#{roles_description} #{I18n.t("shared.roles.role.name.#{role.name}")}"}

    return a.uniq[0].strip unless a.empty?
    ""
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


end