module AppHelper
  def current_path_with_query_params(query_parameters)
    url_for(request.query_parameters.merge(query_parameters))
  end

  def format_number(num)
    num = 0 if num.nil?
    number_to_currency(num, {:unit => '', :separator => ',', :delimiter =>
  '.', :precision => 2})
  end

  def resources_select_options(user, class_name)
    grouped_resources = {}
    grouped_resources[' '] = ['Selecciona el ambito de autorización', '']
    if class_name == Organization
      OrganizationType.all.each do |type|
        grouped_resources[type.description] = Organization.select_options(type)
      end
    elsif class_name == OrganizationType
      grouped_resources['Tipos de organizaciones'] = OrganizationType.select_options
    end

    return grouped_resources
  end

  def roles_select_options(user, class_name)
    roles = []
    roles << ['Selecciona el rol a asignar', '']
    User.roles_select_options(class_name).each do |r|
      roles << r
    end
  end

  def link_doc_target(format)
    format == 'HTML' ? '_self' : '_blank'
  end
end
