class Manager::PeriodsController < Manager::BaseController

  before_action :organization_types, only: [:edit, :new, :create, :update]
  before_action :find_period,   only: [:edit, :update, :destroy]

  def index
    @periods = Period.all.page(params[:page])
  end

  def new
    @period = Period.new
  end

  def create
    @period = Period.new(period_params)
    if @period.save
     # TODO controlar si ha seleccionado copiar desde otro periodo
      msg = t("manager.periods.index.create.success.no_processes_copy")
      redirect_to manager_periods_path, notice: msg
    else
      render :new
    end
  end

  def update
    @period.assign_attributes(period_params)
    if @period.update(period_params)
      redirect_to manager_periods_path
    else
      render "edit"
    end
  end

  def destroy
    if @period.destroy
      msg = t("manager.periods.index.destroy.success")
    else
      msg = t("manager.periods.index.destroy.error")
    end
    redirect_to manager_periods_path, notice: msg
  end

  private
    def period_params
      params.require(:period).permit(:organization_type_id, :description, :started_at, :ended_at, :opened_at, :closed_at)
    end

    def find_period
      @period = Period.find(params[:id])
    end

    def organization_types
      @organization_types = OrganizationType.all.map { |type| [type.description, type.id] }
    end
end
