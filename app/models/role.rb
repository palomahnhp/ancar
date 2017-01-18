class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
             :polymorphic => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  def resource_id_description
    case resource_type
      when 'Organization'
        Organization.find(resource_id).nil? ? 'Todos' : Organization.find(resource_id).description
      when nil
        'Todos'
      else
        resource_id
    end
  end

  def resource_type_description
    resource_type.nil? ? 'Todos' : I18n.t("admin.roles.role.resources.#{resource_type}")
  end

end
