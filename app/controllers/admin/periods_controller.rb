class Admin::PeriodsController < Admin::BaseController

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
      redirect_to admin_periods_path
    else
      render :new
    end
  end

  def update
    @period.assign_attributes(period_params)
    if @period.update(period_params)
      redirect_to admin_periods_path
    else
      render "edit"
    end
  end

  def destroy
    @period.destroy
    redirect_to admin_period_path
  end

  private
    def period_params
      params.require(:period).permit(:organization_type_id, :description, :started_at, :ended_at, :opened_at, :closed_at)
    end

    def find_period
      @period = Period.find(params[:id])
    end

    def organization_types
      @organization_types = OrganizationType.all.map { |type| [type.name, type.id] }
    end
end
