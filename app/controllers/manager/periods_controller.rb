class Manager::PeriodsController < Manager::BaseController

  before_action :organization_types, only: [:edit, :new, :create, :update]
  before_action :get_periods, only: [:edit, :new, :create]
  before_action :find_period, only: [:edit, :update, :destroy]

  def index
    @periods = Period.all.page(params[:page])
  end

  def new
    @period = Period.new
  end

  def edit

  end

  def create
    @period = Period.new(period_params)
    @period.updated_by = current_user.login
    if @period.save
      if params[:period][:id].empty?
        msg = t('manager.periods.create.success.no_processes_copy')
      else
        @period_from = Period.find(params[:period][:id])
        if @period_from
          @period.copy(params[:period][:id], current_user.login)
          msg = t('manager.periods.create.success.processes_copy')
        else
          msg = t('manager.periods.create.error.processes_copy')
        end
      end
      redirect_to manager_periods_path, notice: msg
    else
      render :new
    end
  end

  def update
    @period.assign_attributes(period_params)
    @period.updated_by = current_user.login
    if @period.update(period_params)
      redirect_to manager_periods_path, notice: t('manager.periods.update.success')
    else
      render 'edit'
    end
  end

  def destroy
    if @period.destroy
      msg = t('manager.periods.destroy.success')
    else
      msg = t('manager.periods.destroy.error')
    end
    redirect_to manager_periods_path, notice: msg
  end

  private
    def period_params
      params.require(:period).permit(:organization_type_id, :description, :started_at, :ended_at, :opened_at, :closed_at, :period_id)
    end

    def find_period
      @period = Period.find(params[:id])
    end

    def organization_types
      @organization_types = OrganizationType.all.map { |type| [type.description, type.id] }
    end

    def get_periods
      @periods_from = Period.all.order(:ended_at).map { |type| [type.description, type.id] }
    end

end
