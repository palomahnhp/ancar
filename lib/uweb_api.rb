class UwebApi

  def initialize(data={})
    @user_params = {login: data[:login], user_key: data[:clave_usuario], date: data[:fecha_conexion], development: data[:development]}.with_indifferent_access
  end

  def auth
    # comprueba los paramearos
    if !([@user_params[:login], @user_params[:user_key], @user_params[:date]].all? {|_| _.present?})
      return false
    end
    if (Rails.env.development? || Rails.env.preproduction?) && (!@user_params[:development].nil? && @user_params[:development] == "TRUE")
      # pruebas en desarrollo / preproduccion recupera los datos del usuario de uweb sin realizar comprobaciones
      return @uweb_user if user_data
    else
      # llamada real desde uweb
      return @uweb_user if user_exists? && application_authorized?
    end
    false
  end

  def get_user
    @uweb_user if user_data
  end

  private

    def user_exists?
      response = client.call(:get_status_user_data, message: { ub: {user_key: @user_params[:user_key], date: @user_params[:date]} }).body
      parsed_response = parser.parse((response[:get_status_user_data_response][:get_status_user_data_return]))
      Rails.logger.info('  INFO - UwebApi#user_exists? ') { "Llamada UWEB: get_status_user_data - #{parsed_response}" }
      @uweb_user = uweb_user(parsed_response)
      @user_params[:login] == parsed_response["USUARIO"]["LOGIN"]
    rescue Savon::Error => e
      Rails.logger.error { "  ERROR - UwebApi#user_exists? #{e}" }
      false
    end

    def uweb_user(parsed_response = "")
      user= Hash.new("")
      user[:login]    = parsed_response["USUARIO"]["LOGIN"]
      user[:uweb_id]  = parsed_response["USUARIO"]["CLAVE_IND"]
      user[:name]     = parsed_response["USUARIO"]["NOMBRE_USUARIO"]
      user[:surname]  = parsed_response["USUARIO"]["APELLIDO1_USUARIO"]
      user[:second_surname] = parsed_response["USUARIO"]["APELLIDO2_USUARIO"]
      user[:document] = parsed_response["USUARIO"]["DNI"]
      user[:phone]    = parsed_response["USUARIO"]["TELEFONO"]
      user[:email]    = parsed_response["USUARIO"]["MAIL"]
      user[:official_position] = parsed_response["USUARIO"]["TIPO_USUARIO"] == '1' ? parsed_response["USUARIO"]["CARGO"] : 'PERSONAL EXTERNO'
      user[:sap_den_unit] = parsed_response["USUARIO"]["UNIDAD"]
      user[:pernr]    = parsed_response["USUARIO"]["NUM_PERSONAL"]
      user[:active]    = parsed_response["USUARIO"]["BAJA_LOGICA"] == '0' ? true : false
      return user
    end

    def user_data
      response = client.call(:get_user_data_by_login, message: { ub: {login: @user_params[:login]} }).body
      parsed_response = parser.parse((response[:get_user_data_by_login_response][:get_user_data_by_login_return]))
      @uweb_user = uweb_user(parsed_response)
      @user_params[:login] == parsed_response["USUARIO"]["LOGIN"]
    rescue Savon::Error => e
       Rails.logger.error { "  ERROR - UwebApi#user_data? #{e}" }
       false
    end

    def application_authorized?
      response = client.call(:get_applications_user_list, message: { ub: {user_key: @user_params[:user_key]} }).body
      parsed_response = parser.parse((response[:get_applications_user_list_response][:get_applications_user_list_return]))
      aplication_value = parsed_response["APLICACIONES"]["APLICACION"]
      # aplication_value from UWEB can be an array of hashes or a hash ()
      aplication_value.include?( {"CLAVE_APLICACION" => application_key}) # || aplication_value["CLAVE_APLICACION"] == application_key
    rescue Savon::Error => e
      Rails.logger.error { "  ERROR - UwebApi#application_authorized?: #{e}" }
      false
    end

    def client
      @client ||= Savon.client(wsdl: Rails.application.secrets.uweb_wsdl,
                               raise_errors: true)
    end

    def parser
      @parser ||= Nori.new
    end

    def application_key
      Rails.logger.info { "  INFO - UwebApi#application_key: Aplicación UWEB :  #{Rails.application.secrets.uweb_application_key.to_s}" }
      Rails.application.secrets.uweb_application_key.to_s
    end
end
