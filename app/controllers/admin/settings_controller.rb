class Admin::SettingsController  < Admin::BaseController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  def index
    all_settings = (Setting.all).group_by { |s| s.type  }
    @settings               = all_settings['common']
    @imported_sources       = all_settings['imported_sources_editable']
    @validations_lower_staff = all_settings['validations.lower_staff ']
    @supervisor_email       = all_settings['supervisor.email']
    @send_emails_change_staff = all_settings['send_email.change_staff']
    @rpt_vacancy            = all_settings['rpt.vacancy']
    @rpt_only_grtit         = all_settings['rpt.only_grtit']
    @main_processes_organization = all_settings['main_process_organization']
  end

  def update
    @setting.update(settings_params)
    redirect_to admin_settings_path, notice: t("admin.settings.flash.updated")
  end

private

  def settings_params
    params.require(:setting).permit(:value)
  end

  def set_setting
    @setting = Setting.find(params[:id])
  end
end
