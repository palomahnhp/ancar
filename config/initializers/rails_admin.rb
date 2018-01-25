RailsAdmin.config do |config|

  config.main_app_name = ["Análisis de cargas de trabajo", "Consola"]

  config.included_models = ["AssignedEmployee", "AssignedEmployeesChange",
                            "MainProcess", "SubProcess",
                            "EntryIndicator", "Indicator",
                            "Item", "Metric", "Source",
                            "Unit", "UnitType", "Organization", "OrganizationType", "Period",
                            "User", "Role",
                            "Doc"]

  config.default_items_per_page = 150

  config.model 'Period' do
    navigation_icon 'icon-calendar'
    navigation_label 'Periodos de datos'
    weight -5 # Se usa para ordenar, saltandose el alfabético
    list do
      field :id
      field :description
      field :organization_type do
        pretty_value do
          bindings[:object].organization_type.try(:description)
        end
      end
      field :started_at
      field :ended_at
      field :opened_at
      field :closed_at
    end
  end

  config.model 'MainProcess' do
    parent Period
    list do
      field :id
      field :order
      field :item do
        pretty_value do
          item = bindings[:object].item
          "#{item.try(:description)} # #{item.id}"
        end
      end
      field :period do
        pretty_value do
          period = bindings[:object].period
          "#{period.try(:description)} # #{period.id}"
        end
      end
      field :updated_by do
        pretty_value do
          user = User.find_by(login: bindings[:object].updated_by)
          "#{user.try(:full_name)} # #{user.id}"
        end
      end
      field :updated_at
    end
  end

  config.model 'SubProcess' do
    parent MainProcess
  end

  config.model 'Indicator' do
    parent SubProcess

  end

  config.model 'EntryIndicator' do
    parent Indicator
  end

  config.model 'Metric' do
    parent Indicator
  end

  config.model 'Source' do
    parent Indicator
  end

  config.model 'Task' do
    #   navigation_icon 'icon-user'
    visible false
  end

  config.model 'User' do
    navigation_label 'Usuarios y roles'
    navigation_icon 'icon-user'
    weight -2 # Se usa para ordenar, saltandose el alfabético
  end

  config.model 'Role' do
    navigation_label 'Usuarios y roles'
  end

  config.model 'OrganizationType' do
    navigation_icon 'icon-unit'
    navigation_label 'Organizaciones'
    weight -4 # Se usa para ordenar, saltandose el alfabético
  end

  config.model 'Organization' do
    parent OrganizationType
  end

  config.model 'UnitType' do
    navigation_label 'Organizaciones'
  end

  config.model 'Unit' do
    parent UnitType
  end

  config.model 'AssignedEmployee' do
    navigation_icon 'icon-users'
    navigation_label 'Asignación de puestos/plantilla'
    weight -3 # Se usa para ordenar, saltandose el alfabético
  end

  config.model 'AssignedEmployeesChange' do
    navigation_label 'Asignación de puestos/plantilla'
  end

  config.navigation_static_links = {
      'Ayre' => 'http://ayre.munimadrid.es',
      'Madrid.es' => 'http://madrid.es'
  }

  config.model 'Item' do
    navigation_label 'Generales'
  end

  config.model 'Doc' do
    navigation_label 'Generales'
  end

  # RailsAdmin's historic change observer.
#   config.audit_with :history, User

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  #config.authorize_with :cancancan2

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard  do # mandatory
      i18n_key :dash
    end
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
