class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
      cannot :updates, Period do |period|
      false
      end
    end

    if user.has_role? :supervisor, :any
      can :read, OrganizationType, :id => OrganizationType.with_role(:supervisor, user).pluck(:id)
      can :read, Organization, :id => Organization.where(organization_type_id: OrganizationType.with_role(:supervisor, user).pluck(:id))
    end

    if user.has_role? :validator, :any
      can :read, Organization, :id => Organization.with_role(:validator, user).pluck(:id)
      can :approval, Period, :organizations_id => Organization.with_role(:validator, user).pluck(:id)
    end

    if user.has_role? :interlocutor, :any
      can [:updates, :read], Organization, :id => Organization.with_role(:interlocutor, user).pluck(:id)
      cannot :updates, Period do |period|
        period.not_yet_open? || period.close_entry?
      end
    end

    if user.has_role? :reader, :any
      can :read, OrganizationType, :id => OrganizationType.with_role(:reader, user).pluck(:id)
      can :read, Organization, :id => Organization.where(organization_type_id: OrganizationType.with_role(:supervisor, user).pluck(:id))
    end
  end

end
