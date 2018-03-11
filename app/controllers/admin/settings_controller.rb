class Admin::SettingsController  < Admin::BaseController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  def index
    all_settings = (Setting.all).group_by { |s| s.type  }
    @settings               = all_settings['common']
    @imported_sources       = all_settings['imported_source']
    @validations            = all_settings['validation']
    @send_emails_change_staff = all_settings['send_email.change_staff']
    @rpt_vacancy            = all_settings['rpt.vacancy']
    @rpt_without_grtit      = all_settings['rpt.without_grtit']
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
