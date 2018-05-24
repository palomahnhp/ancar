class Doc  < ActiveRecord::Base
  belongs_to :organization_type

  validates_presence_of :name, :url
  validates_inclusion_of :format, in: %w[PDF JPG PNG HTML]

  scope :for_all, -> { where(organization_type_id: nil, role: nil  ) }
  scope :auth,    ->(user) { where(organization_type_id: user.auth_organization_types_ids.uniq << nil)  }
  scope :reader,        -> {where("role like ?", '%reader%')}
  scope :interlocutor,  -> {where("role like ?", '%interlocutor%')}
  scope :validator,     -> {where("role like ?", '%validator%')}
  scope :supervisor,    -> {where("role like ?", '%supervisor%')}
  scope :administrator, -> {all}

  def self.to_show(user)
    user_roles = user.roles.map { |role| role.name }.uniq
    return all if user_roles.include? 'admin'

    reader        = user_roles.include?('reader')
    interlocutor  = user_roles.include?('interlocutor')
    validator     = user_roles.include?('validator')
    supervisor    = user_roles.include? 'supervisor'

    case
      when supervisor
        auth(user).supervisor
      when interlocutor
        auth(user).interlocutor
      when validator
        auth(user).validator
      when reader
        auth(user).readerr
    end
  end
end