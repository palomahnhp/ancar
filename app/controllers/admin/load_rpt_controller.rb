class Admin::LoadRptController < Admin::BaseController
  require 'stringio'

  def index
    @year = params[:year].present? ? params[:year] : Date.today.year - 1
    @organizations = Organization.all.order(:organization_type_id, :description)
  end

  def update
    error = []
    attrs = load_rpt_params
    puts 'Lanzar actualización de rpt para el año' + params[:year].to_s
    StringIO.open do |strio|
      error << LoadRptJob.perform_now(params[:year], params[:file].tempfile)
      if error.present?
        flash[:error] = error.to_s
      end
    end
    redirect_to admin_load_rpt_index_path(year: params[:year])
  end

  private

  def load_rpt_params
    params.permit(:file)
  end
end
