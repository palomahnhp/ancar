class Supervisor::PeriodsController < Supervisor::BaseController

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
        msg = t('supervisor.periods.create.success.no_processes_copy')
      else
        @period_from = Period.find(params[:period][:id])
        if @period_from
          @period.copy(params[:period][:id], current_user.login)
          msg = t('supervisor.periods.create.success.processes_copy')
        else
          msg = t('supervisor.periods.create.error.processes_copy')
        end
      end
      redirect_to supervisor_periods_path, notice: msg
    else
      render :new
    end
  end

  def update
    @period.assign_attributes(period_params)
    @period.updated_by = current_user.login
    if @period.update(period_params)
      redirect_to supervisor_periods_path, notice: t('supervisor.periods.update.success')
    else
      render 'edit'
    end
  end

  def destroy
    if @period.destroy
      msg = t('supervisor.periods.destroy.success')
    else
      msg = t('supervisor.periods.destroy.error')
    end
    redirect_to supervisor_periods_path, notice: msg
  end

  private
    def period_params
      params.require(:period).permit(:organization_type_id, :description, :started_at, :ended_at, :opened_at, :closed_at, :period_id)
    end

    def find_period
      @period = Period.find(params[:id])
    end


end
