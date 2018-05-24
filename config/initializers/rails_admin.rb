RailsAdmin.config do |config|

  config.main_app_name = ["Análisis de cargas de trabajo", "Consola"]

  config.included_models = ["AssignedEmployee", "AssignedEmployeesChange",
                            "MainProcess", "SubProcess",
                            "EntryIndicator", "Indicator",
                            "Item", "Metric", "Source",
                            "Unit", "UnitType", "Organization", "OrganizationType", "Period",
                            "User", "Role", "Doc", "Setting", "Rpt", "FirstLevelUnit", "UnitRptAssignation"]

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
          link_object = bindings[:object].item
          path = bindings[:view].show_path(model_name: 'Item', id: link_object.id)
          bindings[:view].tag(:a, href: path) << "#{link_object.id} #{link_object.description}"
        end
      end
      field :period do
        pretty_value do
          link_object = bindings[:object].period
          path = bindings[:view].show_path(model_name: 'Period', id: link_object.id)
          bindings[:view].tag(:a, href: path) << link_object.description
        end
      end
      field :updated_by do
        pretty_value do
          link_object = User.find_by(login: bindings[:object].updated_by)
          path = bindings[:view].show_path(model_name: 'User', id: link_object.id)
          bindings[:view].tag(:a, href: path) << link_object.full_name
        end
      end
      field :updated_at
    end
  end

  config.model 'SubProcess' do
    parent MainProcess
    list do
      field :id
      field :order
      field :item do
        pretty_value do
          link_object = bindings[:object].item
          path = bindings[:view].show_path(model_name: 'Item', id: link_object.id)
          bindings[:view].tag(:a, href: path) << "#{link_object.id} #{link_object.description}"
        end
      end
      field :main_process do
        pretty_value do
          link_object = bindings[:object].main_process
          path = bindings[:view].show_path(model_name: 'MainProcess', id: link_object.id)
          bindings[:view].tag(:a, href: path) << "#{link_object.order} #{link_object.item.description}"
        end
      end
      field :updated_by do
        pretty_value do
          link_object = User.find_by(login: bindings[:object].updated_by)
          path = bindings[:view].show_path(model_name: 'User', id: link_object.id)
          bindings[:view].tag(:a, href: path) << link_object.full_name
        end
      end
      field :updated_at
    end
  end

  config.model 'Indicator' do
    parent SubProcess
    list do
      field :id
      field :order
      field :item do
        pretty_value do
          link_object = bindings[:object].item
          path = bindings[:view].show_path(model_name: 'Item', id: link_object.id)
          bindings[:view].tag(:a, href: path) << "#{link_object.id} #{link_object.description}"
        end
      end

      field :sub_process do
        pretty_value do
          link_object = bindings[:object].sub_process
          path = bindings[:view].show_path(model_name: 'SubProcess', id: link_object.id)
          bindings[:view].tag(:a, href: path) << "#{link_object.order} #{link_object.item.description}"
        end
      end

      field :updated_by do
        pretty_value do
          link_object = User.find_by(login: bindings[:object].updated_by)
          path = bindings[:view].show_path(model_name: 'User', id: link_object.id)
          bindings[:view].tag(:a, href: path) << link_object.full_name
        end
      end
      field :updated_at
    end
  end

  config.model 'EntryIndicator' do
    parent Indicator
  end

  config.model 'Metric' do
    parent Indicator
    list do
      field :id
      field :item do
        pretty_value do
          link_object = bindings[:object].item
          path = bindings[:view].show_path(model_name: 'Item', id: link_object.id)
          bindings[:view].tag(:a, href: path) << "#{link_object.id} #{link_object.description}"
        end
      end
      field :updated_at
    end
  end

  config.model 'Source' do
    parent Indicator
    list do
      field :id
      field :item do
        pretty_value do
          link_object = bindings[:object].item
          path = bindings[:view].show_path(model_name: 'Item', id: link_object.id)
          bindings[:view].tag(:a, href: path) << "#{link_object.id} #{link_object.description}"
        end
      end
      field :updated_at
    end
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
    list do
      field :id
      field :organization_type do
        pretty_value do
          link_object = bindings[:object].organization_type
          path = bindings[:view].show_path(model_name: 'Item', id: link_object.id)
          bindings[:view].tag(:a, href: path) << link_object.description
        end
      end
      field :description
      field :short_description
      field :sap_id
      field :order
      field :updated_by do
        pretty_value do
          link_object = User.find_by(login: bindings[:object].updated_by)
          path = bindings[:view].show_path(model_name: 'User', id: link_object.id)
          bindings[:view].tag(:a, href: path) << link_object.full_name
        end
      end
    end
  end

  config.model 'UnitType' do
    navigation_label 'Organizaciones'
    list do
      field :id
      field :organization_type do
        pretty_value do
          link_object = bindings[:object].organization_type
          path = bindings[:view].show_path(model_name: 'OrganizationType', id: link_object.id)
          bindings[:view].tag(:a, href: path) << link_object.description
        end
      end
      field :description
      field :updated_by do
        pretty_value do
          link_object = User.find_by(login: bindings[:object].updated_by)
          path = bindings[:view].show_path(model_name: 'User', id: link_object.id)
          bindings[:view].tag(:a, href: path) << link_object.full_name
        end
      end
    end
  end

  config.model 'Unit' do
    parent UnitType
    list do
      field :id
      field :unit_type do
        pretty_value do
          link_object = bindings[:object].unit_type
          path = bindings[:view].show_path(model_name: 'Unit', id: link_object.id)
          bindings[:view].tag(:a, href: path) << link_object.description
        end
      end
      field :description_sap
      field :sap_id
      field :order
      field :updated_by do
        pretty_value do
          link_object = User.find_by(login: bindings[:object].updated_by)
          path = bindings[:view].show_path(model_name: 'User', id: link_object.id)
          bindings[:view].tag(:a, href: path) << link_object.full_name
        end
      end
    end
  end

  config.model 'FirstLevelUnit' do
    navigation_label 'Organizaciones'
  end

  config.model 'Validation' do
    navigation_label 'Validaciones'
  end

  config.model 'Rpt' do
    navigation_label 'Rpts'
  end

  config.model 'UnitRptAssignation' do
    navigation_label 'Rpts'
  end

  config.model 'AssignedEmployee' do
    navigation_icon 'icon-users'
    navigation_label 'Asignación de puestos/plantilla'
    list do
      field :id
      field :official_group_id do
        pretty_value do
          bindings[:object].official_group.try(:name)
        end
      end
      field :staff_of_type
      field :staff_of_id
      field :unit do
        pretty_value do
          if bindings[:object].unit_id.present?
            "#{Unit.find(bindings[:object].unit_id).try(:description_sap)} - #{Unit.find(bindings[:object].unit_id).organization.short_description}"
          end
        end
      end
      field :quantity
      field :period_id do
        pretty_value do
          link_object = bindings[:object].period
          path = bindings[:view].show_path(model_name: 'Period', id: link_object.id)
          bindings[:view].tag(:a, href: path) << link_object.description
        end
      end
      field :justification
      field :justified_at
      field :justified_by do
        pretty_value do
          link_object = User.find_by(login: bindings[:object].justified_by)
          if link_object.present?
            path = bindings[:view].show_path(model_name: 'User', id: link_object.id)
            bindings[:view].tag(:a, href: path) << link_object.full_name
          end
        end
      end
      field :pending_verification
    end
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

  config.model 'Setting' do
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
