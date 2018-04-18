class Admin::UnitRptAssignationsController < Admin::BaseController
  Thread.abort_on_exception = true

  def index
   year_to_process
   @organizations_assignated = UnitRptAssignation.select(:organization_id).by_year(@assignation_year).order(:organization_id).distinct.to_a

    respond_to do |format|
      format.html
      format.csv { send_data @rpts.to_csv }
      format.xls # { send_data @rpts.to_csv(col_sep: "\t") }
    end
  end

  def init
    resp = UnitRptAssignation.init(params[:year].to_i) if params[:init].present?
    message = "Initialization done." if resp.present?
    message = "Initialization error." if resp.blank?
    redirect_to admin_unit_rpt_assignations_path, notice: message
  end

  def copy
    resp = UnitRptAssignation.copy(params[:year].to_i) if params[:copy].present?
    message = "Capia de asignaciones hecha." if resp.present?
    message = "Copy error." if resp.blank?
    redirect_to admin_unit_rpt_assignations_path, notice: message
  end

  def import
    tmpfilepath = params[:file].present? ? params[:file].tempfile.path : ''
    if File.exist?(tmpfilepath)
      filepath = 'public/imports/' + params[:file].original_filename
      begin
        FileUtils.mv(tmpfilepath, filepath)
        current_user.create_activity key: 'RPT import', owner: current_user, params: { file: filepath, year: params[:year] }
        UnitAssignationJob.perform_later(params[:year], File.extname(params[:file].original_filename), filepath)
        message =  'Lanzada tarea de importación. Carga disponible en unos minutos'
      rescue StandardError => e
        puts  'Error al copiar el fichero de importación. No se ha iniciado el proceso: ' + filepath
        puts e.message
        puts e.to_s
      end
    else
      message =  'Error al obtener el fichero de importación. No se ha iniciado el proceso: ' + tmpfilepath
    end
    redirect_to admin_unit_rpt_assignations_path, notice: message
  end

  def update_assignations
    resp = UnitRptAssignation.update(params[:year].to_i, params[:assign], params[:unassign])
    message = "Assignation done." if resp.present?
    message = "Assignation error." if resp.blank?
    redirect_to show_organization_admin_unit_rpt_assignations_path(organization: params[:organization]), notice: message
  end

  def show_organization
    year_to_process
    @organization = Organization.find_by(id: params[:organization])
  end

  private

  def load_rpt_params
    params.permit(:file, :year)
  end

  def year_to_process
    @rpt_year = @assignation_year = nil
    @process_year     =  Period.unscoped.order_by_started_at.first.started_at.year
    @assignation_year =  UnitRptAssignation.order(:year).last.year if UnitRptAssignation.order(:year).present?
    @rpt_year         =  Rpt.order(:year).last.year if Rpt.order(:year).present?
  end
end
