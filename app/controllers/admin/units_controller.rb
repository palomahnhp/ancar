class Admin::UnitsController < Admin::BaseController
  before_action :set_admin_unit, only: [:show, :edit, :update, :destroy]

  def index
    @admin_units = Admin::Unit.all
  end

  def show
  end

  def new
    @admin_unit = Admin::Unit.new
  end

  def edit
  end

  def create
    @admin_unit = Admin::Unit.new(admin_unit_params)

      if @admin_unit.save
        redirect_to @admin_unit, notice: 'Unit was successfully created.'
      else
        render :new
      end
  end

  def update
    if @admin_unit.update(admin_unit_params)
      redirect_to @admin_unit, notice: 'Unit was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @admin_unit.destroy
    redirect_to admin_units_url, notice: 'Unit was successfully destroyed.'
  end

  private

    def set_admin_unit
      @admin_unit = Admin::Unit.find(params[:id])
    end

    def admin_unit_params
      params.fetch(:admin_unit, {})
    end
end
