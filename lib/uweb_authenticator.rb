class UwebAuthenticator
  require "logger"

  def initialize(data={})
    @logger = Logger.new('session.log', 'weekly')
    @logger.level = Logger::INFO

    @user_params = {login: data[:login], user_key: data[:clave_usuario], date: data[:fecha_conexion], development: data[:development]}.with_indifferent_access
  end

  def auth
    return false unless [@user_params[:login], @user_params[:user_key], @user_params[:date]].all? {|_| _.present?}
    return @uweb_user if user_data && (!@user_params[:development].nil? && @user_params[:development] == "TRUE") && Rails.env.development?
    return @uweb_user if user_exists? && application_authorized?
    false
  end

  private

    def user_exists?
      response = client.call(:get_status_user_data, message: { ub: {user_key: @user_params[:user_key], date: @user_params[:date]} }).body
      parsed_response = parser.parse((response[:get_status_user_data_response][:get_status_user_data_return]))
      @logger.info('UwebAuthenticator#user_exists? ') { "Llamada UWEB: get_status_user_data - #{parsed_response}" }
      @uweb_user = uweb_user(parsed_response)
      @user_params[:login] == parsed_response["USUARIO"]["LOGIN"]
    rescue  Exception  => e
      @logger.error('UwebAuthenticator#user_exists? ') { "Error llamada UWEB: get_status_user_data - #{@user_params}" }
      puts e
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
      user[:official_position] = parsed_response["USUARIO"]["CARGO"]
      user[:pernr]    = parsed_response["USUARIO"]["NUM_PERSONAL"]
      return user
    end

    def user_data
      response = client.call(:get_user_data_by_login, message: { ub: {login: @user_params[:login]} }).body
      parsed_response = parser.parse((response[:get_user_data_by_login_response][:get_user_data_by_login_return]))
      @logger.info('UwebAuthenticator#uweb_user: ') { "Llamada UWEB: get_user_data - #{parsed_response}" }
      @uweb_user = uweb_user(parsed_response)

      @user_params[:login] == parsed_response["USUARIO"]["LOGIN"]
    rescue  Exception  => e
       puts e
       false
    end

    def application_authorized?
      response = client.call(:get_applications_user_list, message: { ub: {user_key: @user_params[:user_key]} }).body
      parsed_response = parser.parse((response[:get_applications_user_list_response][:get_applications_user_list_return]))
      @logger.info('UwebAuthenticator#application_authorized?: ') { "Llamada UWEB: application_user_list - #{parsed_response}" }
      aplication_value = parsed_response["APLICACIONES"]["APLICACION"]

      # aplication_value from UWEB can be an array of hashes or a hash ()
      aplication_value.include?( {"CLAVE_APLICACION" => application_key}) # || aplication_value["CLAVE_APLICACION"] == application_key
    rescue Savon::Error => e
      @logger.error('UwebAuthenticator#application_authorized?: ') { "ERROR UWEB: application_user_list #{@user_params}" }
      false
    end

    def client
      @logger.info('UwebAuthenticator#client: ') { "creación cliente UWEB WSDL :  #{Rails.application.secrets.uweb_wsdl}" }
      @client ||= Savon.client(wsdl: Rails.application.secrets.uweb_wsdl,
                               raise_errors: true)
    end

    def parser
      @parser ||= Nori.new
    end

    def application_key
      @logger.info('UwebAuthenticator#application_key: ') { "Aplicación UWEB :  #{Rails.application.secrets.uweb_application_key.to_s}" }
      Rails.application.secrets.uweb_application_key.to_s
    end
end
