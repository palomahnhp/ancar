class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
    end

    if user.has_role? :supervisor, :any
      can :read, OrganizationType, :id => OrganizationType.with_role(:superviabisor, user).pluck(:id)
      can :read, Organization, :id => Organization.where(organization_type_id: OrganizationType.with_role(:supervisor, user).pluck(:id))
    end

    if user.has_role? :validator, :any
      can :read, Organization, :id => Organization.with_role(:validator, user).pluck(:id)
      can :approval, Period, :organizations_id => Organization.with_role(:validator, user).pluck(:id)
    end

    if user.has_role? :interlocutor, :any
      can [:updates, :read], Organization, :id => Organization.with_role(:interlocutor, user).pluck(:id)
    end

    if user.has_role? :reader, :any
      can :read, OrganizationType, :id => OrganizationType.with_role(:reader, user).pluck(:id)
      can :read, Organization, :id => Organization.where(organization_type_id: OrganizationType.with_role(:supervisor, user).pluck(:id))
    end
  end
    #
    # The first argument - action you are giving the user permission to do.
    #                       :manage it will apply to every action.
    #                       :read, :create, :update and :destroy.
    #
    # The second argument  - resource the user can perform the action on.
    #                         :all it will apply to every resource.
    #                         Class
    #
    # The third argument   - optional hash of conditions to further filter the
    # objects. For example, here the user can only update published articles.
    #
    #            can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

end
