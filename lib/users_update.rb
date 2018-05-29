class UsersUpdate

  def initialize
  end

  def run
    activity_log(self.class, "Inicio de actualizacion de usuarios", :info)
    users_update
    notify_admin
    activity_log(self.class, "Fin de actualizacion de usuarios:", :info)
  end

  def users_update
    begin
      User.all.each do |user|
        if user.uweb_update!
          user.directory_update!
          activity_log(self.class, user.login + " Actualizado ", :info)
        else
          activity_log(self.class, user.login + " Error actualizando ", :error)
        end
      end
    rescue StandardError => e
         activity_log(self.class, "Excepcion: error actualizando Users " + e.message, :error)
    end
    activity_log(self.class, "Finaliza actualizacion de usuarios", :info)
  end

  private

  def notify_admin
    begin
      AdminMailer.importer_email(message: 'Termina el proceso de actualizacion de usuarios').deliver_now  # deliver_later
    rescue StandardError => e
      Rails.logger.error(self.class.to_s + ' - '  +  e.message)
    end
  end

  def activity_log(class_name, message, type)
    log_message = class_name.to_s + ' - ' + Time.zone.now.to_s + ' - ' + message
    if type == :error
      Rails.logger.error log_message
    else
      Rails.logger.info  log_message
    end
  end

end



