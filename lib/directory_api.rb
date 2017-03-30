class DirectoryApi

  def client
    @directory_client ||= Savon.client(wsdl: Rails.application.secrets.directorio_wsdl,encoding: 'ISO-8859-1', raise_errors: true)
  end

  def get_units(cod_organico)
    message_params = { aplicacion: Rails.application.secrets.directorio_application_key, codOrganico: cod_organico}
    request(:buscar_dependencias, message_params)
  end

  def hierarchical_search(id_unidad, query_type)
    query_type_int = {only_sons: 1, all_down: 2, all_up: 3}[query_type]
    message_params = { aplicacion: Rails.application.secrets.directorio_application_key,
                       idUnidad: id_unidad, tipoConsulta: query_type_int}
    request(:busqueda_jerarquica, message_params)
  end

  def employees_data(params)
    params[:i_tipoConsulta] = {only_unit: 1, all_down: 2}[params[:i_tipoConsulta]] if params[:i_tipoConsulta].present?
    message_params = {aplicacion: Rails.application.secrets.directorio_application_key}
    message_params.merge!(params)
    request(:datos_empleados, message_params)
  end

  def request(operation, message_params)
    response = client.call(operation.to_sym, message: message_params).body
    parsed_response = parser.parse(response[(operation.to_s + '_response').to_sym][(operation.to_s + '_return').to_sym])
  rescue Savon::Error => e
    puts "#{operation} - #{message_params} - Error Savon: #{e}"
    false
  end

  private
  def parser
    @parser ||= Nori.new
  end

  def application_key
    Rails.logger.info { "  INFO - UwebAuthenticator#application_key: Aplicación UWEB :  #{Rails.application.secrets.uweb_application_key.to_s}" }
    Rails.application.secrets.uweb_application_key.to_s
  end
end
