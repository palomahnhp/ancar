class SupervisorMailer < ApplicationMailer
  default from: 'ancar_no_replay@madrid.es'

  def change_staff_email(data)
    if Setting.find_by_key("send_email.change_staff.#{data[:period].organization_type.acronym}")
      @period = data[:period]
      @text = data[:change] == 'open' ? 'Se ha iniciado un ajuste de la plantilla.' :  'Se ha cancelado un ajuste de la plantilla.'
      @unit = data[:unit]
      @user = data[:user]
      @type = data[:change]
      to = Setting.find_by_key("supervisor.email.#{@period.organization_type.acronym}").value
      subject = "Cambio de plantilla: #{@unit.description_sap} / #{@unit.organization.description} "
      mail(to: "<#{to}>", subject: subject )
      AssignedEmployeesChange.emailed(@period.id, @unit.id) if data[:change] == 'open'
    end
  end
end