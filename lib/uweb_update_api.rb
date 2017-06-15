class UwebUpdateApi

  def initialize(user_key)
    params(user_key) 
  end 

  def client
    Rails.logger.info { "  INFO - UwebUpdateApi#wsdl: :  #{Rails.application.secrets.uweb_update_wsdl.to_s}" }
    @client ||= Savon.client(wsdl: Rails.application.secrets.uweb_update_wsdl, encoding: 'ISO-8859-1', raise_errors: true)
  end

  def insert_profile(user)
    message_params = @params
    message_params[:keyUserRelation] = user.uweb_id
    message_params[:loginUserRelation] =  user.login
    request(:insert_profile_login, message_params)
  end

  def remove_profile(user)
    message_params = @params
    message_params[:keyUserRelation] = user.uweb_id
    message_params[:loginUserRelation] =  user.login
    request(:remove_profile_login, message_params)
  end

  def request(operation, message_params)
    response = client.call(operation.to_sym, message: { ub: message_params }).body
    parsed_response = parser.parse(response[(operation.to_s + '_response').to_sym][(operation.to_s + '_return').to_sym])
  rescue Savon::Error => e
    puts "#{operation} - #{message_params} - Error Savon: #{e}"
    false
  end

  private
  def parser
    @parser ||= Nori.new
  end

  def params(user_key)
    @params ||= {
        keyApp:      Rails.application.secrets.uweb_update_app,
        keyProfileConnect:  Rails.application.secrets.uweb_update_profile,
        keyProfileRelation: Rails.application.secrets.uweb_update_key_profile_connect,
        keyUserConnect: user_key ,
        keyUserRelation: ' ' ,
        keyWService: Rails.application.secrets.uweb_update_key,
        loginUserRelation: ' ' ,
        pwdWservice: Rails.application.secrets.uweb_update_pwd
        }
  end


end
