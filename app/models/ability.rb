class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :validator
      can :read, EntryIndicator
      can :manage, OrganizationType, :id => OrganizationType.with_role(:validator, user).pluck(:id)
      can :manage, Period, :organizations_type_id => OrganizationType.with_role(:validator, user).pluck(:id)
    elsif user.has_role? :viewer
      can :read, :all
    else
      can :manage, :all
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
