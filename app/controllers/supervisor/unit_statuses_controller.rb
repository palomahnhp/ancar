class Supervisor::UnitStatusesController < ApplicationController
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
      @supervisor_unit_statuses = UnitStatus.new(params[:id])
      @supervisor_unit_statuses.create_all
    end

    def set_supervisor_unit_status
      @supervisor_unit_statuses = UnitStatus.new(params[:id])
      @supervisor_unit_statuses.create(params[:unit_id])
      @supervisor_unit_status = @supervisor_unit_statuses.unit_statuses.first
    end

end
