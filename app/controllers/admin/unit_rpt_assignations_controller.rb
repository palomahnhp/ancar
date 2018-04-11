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
    message = "Initialization error." unless resp.present?
    redirect_to admin_unit_rpt_assignations_path, notice: message
  end

  def copy
    resp = UnitRptAssignation.copy(params[:year].to_i) if params[:copy].present?
    message = "Capia de asignaciones hecha." if resp.present?
    message = "Copy error." unless resp.present?
    redirect_to admin_unit_rpt_assignations_path, notice: message
  end

  def import
    filepath = params[:file].tempfile.path
    if File.exists?(filepath)
      current_user.create_activity(key: 'Importar asignacion de unidades para RPT',
                                   params: { file: filepath }, owner: current_user)
      message =  'Lanzada tarea de importación. Carga disponible en unos minutos'
      begin
        Thread.new do
          Importers::UnitRptAssignationImporter.new(params[:year], File.extname(params[:file].original_filename), filepath).run
          ActiveRecord::Base.connection.close
        end
      rescue StandardError => e
        Rails.logger.info (params[:controller] + '#' + params[:action] + ' - '  + Time.zone.now.to_s +  " EXCEPTION: " + e.inspect + " MESSAGE: " + e.message )
      end

    else
      message =  'Error al obtener el fichero de importación. No se ha iniciado el proceso: ' + filepath
    end
    redirect_to admin_unit_rpt_assignations_path, notice: message
  end

  def update_assignations
    resp = UnitRptAssignation.update(params[:year].to_i, params[:assign], params[:unassign])
    message = "Assignation done." if resp.present?
    message = "Assignation error." unless resp.present?
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
