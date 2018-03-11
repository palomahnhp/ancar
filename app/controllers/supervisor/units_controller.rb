class Supervisor::UnitsController < Supervisor::BaseController
  def index
    year_to_process
    @organization_types = OrganizationType.with_roles(:supervisor, current_user).ids
    @organization_types = OrganizationType.all if current_user.has_role? :admin
#    @rpts_group = Rpt.select('year, organization_id, unit_id, den_unidad, count(*) as regs').
#        group(:year, :organization_id, :unit_id, :den_unidad).
#    order(:year, :organization_id, :unit_id, :den_unidad)
    @organizations = Organization.where(organization_type_id: @organization_types.ids )
#    @rpts = Rpt.where(organization_id: @organizations.ids, year: @year)
    respond_to do |format|
      format.html
      format.csv { send_data @rpts.to_csv }
      format.xls # { send_data @rpts.to_csv(col_sep: "\t") }
    end
  end

  def import
    if Rpt.import(params[:file])
      message = "Fichero importado."
    else
      message = "Error en la importación."
    end
    redirect_to admin_rpts_path, notice: message
  end

  def detail
    @organization = Organization.find(params[:id])
    @units = @organization.units
    @year = params[:year]
  end

  private

  def load_rpt_params
    params.permit(:file, :year)
  end

  def year_to_process
    @rpt_year     = Rpt.order(:year).last.year if Rpt.order(:year).present?
    @rpt_year     = @process_year unless Rpt.order(:year).present?
    @year         = params[:year].present? ? params[:year] : @rpt_year
  end
end
