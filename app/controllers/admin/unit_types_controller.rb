class Admin::UnitTypesController < Admin::BaseController
  before_action :set_admin_unit_type, only: [:show, :edit, :update, :destroy]

  def index
    @admin_unit_types = UnitType.all
  end

  def show
  end

  def new
    @admin_unit_type = Admin::UnitType.new
  end

  def edit
  end

  def create
    @admin_unit_type = Admin::UnitType.new(admin_unit_type_params)
    if @admin_unit_type.save
      redirect_to @admin_unit_type, notice: 'Unit type was successfully created.'
    else
      render :new
    end
  end

  def update
    if @admin_unit_type.update(admin_unit_type_params)
      redirect_to @admin_unit_type, notice: 'Unit type was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @admin_unit_type.destroy
    redirect_to admin_unit_types_url, notice: 'Unit type was successfully destroyed.'
  end

  private

    def set_admin_unit_type
      @admin_unit_type = Admin::UnitType.find(params[:id])
    end

    def admin_unit_type_params
      params.fetch(:admin_unit_type, {})
    end
end
