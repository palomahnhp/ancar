class Admin::RptsController < Admin::BaseController
  Thread.abort_on_exception = true

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
    filepath = params[:file].present? ? params[:file].tempfile.path : ''

    if File.exists?(filepath)
     current_user.create_activity key: 'RPT import', owner: current_user, params: { file: filepath, year: params[:year] }
     message =  'Lanzada tarea de importación. Carga disponible en unos minutos'
     begin
      Thread.new do
        Importers::RptImporter.new(params[:year], File.extname(params[:file].original_filename), params[:file].original_filename, filepath).run
        ActiveRecord::Base.connection.close
      end
     rescue
       Rails.logger.info (params[:controller] + '#' + params[:action] + ' - '  + Time.zone.now.to_s +  " EXCEPTION: " + e.inspect + " MESSAGE: " + e.message )
     end

    else
      message =  'Error al obtener el fichero de importación. No se ha iniciado el proceso: ' + filepath
    end
    redirect_to admin_rpts_path, notice: message
  end

  private

  def load_rpt_params
    params.permit(:file, :year)
  end

end
