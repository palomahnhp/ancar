class Admin::RptsController < Admin::BaseController

  def index
    @year = Rpt.maximum(:year)
    @rpts_group = Rpt.select('year, organization_id, unit_id, den_unidad, count(*) as regs').
        group(:year, :organization_id, :unit_id, :den_unidad).
        order(:year, :organization_id, :unit_id, :den_unidad)

    @organizations = Organization.all

    respond_to do |format|
      format.html
      format.xls # { send_data @rpts.to_csv(col_sep: "\t") }
    end
  end

  def import
    resp = RptImportJob.set(wait: 15.seconds).perform_later(params[:year], File.extname(params[:file].original_filename), params[:file].path)
    redirect_to admin_rpts_path, notice: 'Lanzada tarea de importación. Carga disponible en unos minutos'
  end

  private

  def load_rpt_params
    params.permit(:file, :year)
  end

end
