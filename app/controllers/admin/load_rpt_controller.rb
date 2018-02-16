class Admin::LoadRptController < Admin::BaseController

  def index
    @year = params[:year].present? ? params[:year] : Date.today.year - 1
    @organizations = Organization.all.order(:organization_type_id, :description)
  end

  def update
    error = []
    if params[:organization].present?
       params[:organization].each do |organization_id|
         organization = Organization.find(organization_id[1])
         puts 'Lanzar actualización de ' + organization.description
         error << LoadRptJob.perform_now(params[:year], organization_id[1])
         flash[:notice] = 'Lanzada la carga de plantilla para las unidades indicadas'
       end
    end
    if error.present?
      flash[:error] = error.to_s
    end
    redirect_to admin_load_rpt_index_path(year: params[:year])
  end
end
