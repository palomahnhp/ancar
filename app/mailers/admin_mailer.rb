class AdminMailer < ApplicationMailer
  default from: 'ancar_no_reply@madrid.es'

  def importer_email(data)
    begin
      @message = data[:message]

      to = Setting.find_by(key: 'app_email').value
      subject = "Importer:" + @message
      mail(to: "<#{to}>", subject: subject)
      Rails.logger.info (self.class.to_s + ' - ' + Time.zone.now.to_s + ' - Enviado mail: ' + to + ' - ' + subject )
    rescue  StandardError => e
      Rails.logger.error (self.class.to_s + ' - ' + Time.zone.now.to_s + ' - Error enviando mail - message: ' + e.to_s + ' - ' +
          to + ' - ' + subject )
    end
  end
end
