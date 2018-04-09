class Admin::RptsController < Admin::BaseController

  def index
    @year = Rpt.maximum(:year)
    @rpts_group = Rpt.select('year, organization_id, unit_id, den_unidad, count(*) as regs').
        group(:year, :organization_id, :unit_id, :den_unidad).
        order(:year, :organization_id, :unit_id, :den_unidad)
    @rpts = Rpt.by_year(@year)
    @organizations = Organization.all
    @organization_types = OrganizationType.all

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def import
    filepath = "public/imports/#{params[:file].original_filename}"
    if File.rename(params[:file].path, filepath)
     message =  'Lanzada tarea de importación. Carga disponible en unos minutos'
     resp = RptImportJob.perform_later(params[:year], File.extname(params[:file].original_filename), filepath)
    else
      message =  'Error al obtener el fichero de importación. No se ha iniciado el proceso '
    end
    redirect_to admin_rpts_path, notice: message

  end

  private

  def load_rpt_params
    params.permit(:file, :year)
  end

end
