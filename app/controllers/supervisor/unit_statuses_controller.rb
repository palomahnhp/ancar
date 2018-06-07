class Supervisor::UnitStatusesController < Supervisor::BaseController
  before_action :set_supervisor_unit_status, only: [:show]
  before_action :set_supervisor_unit_statuses, only: [:index]


  # GET /supervisor/unit_statuses
  # GET /supervisor/unit_statuses.json
  def index
  end

  # GET /supervisor/unit_statuses/1
  # GET /supervisor/unit_statuses/1.json
  def show
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_supervisor_unit_statuses
      @period = Period.find(params[:id])
    end

    def set_supervisor_unit_status
      @period = Period.find(params[:id])
      @unit       = Unit.find(params[:unit_id])
      @employees  = AssignedEmployee.by_unit(@unit.id).by_period(@period).unit_justified
                        .presence
      @validations = @unit.validations.by_period(@period).presence
      @approval   = @unit.approvals.by_period(@period).take.presence
    end
end
