class Admin::UnitsController < Admin::BaseController
  before_action :set_unit, only: [:show, :edit, :update, :destroy]

  def index
    @search = Unit.search(params[:q])
    @units  = @search.result.includes(:organization, :unit_type).page(params[:page])
  end

  def new
    @unit = Unit.new
  end

  def edit
  end

  def create
    @unit = Unit.new(unit_params)
    if @unit.save
      redirect_to admin_units_path, notice: 'Unit was successfully created.'
    else
      render :new
    end
  end

  def update
    if @unit.update(unit_params)
      redirect_to admin_units_path, notice: t('admin.actions.update')
    else
      render :edit
    end
  end

  def destroy
    if check_destroy
      @unit.destroy
      message = 'Unidad eliminada.'
    else
      message = 'No se puede eliminar ya que tiene objetas asignados.'
    end
    redirect_to admin_units_path, notice: message
  end

  private

  def set_unit
    @unit = Unit.find(params[:id])
  end

  def unit_params
    params.require(:unit).permit(:unit_type, :organization, :description, :sap_id, :order)
  end

  def check_destroy
    return false if @unit.unit_type || @unit.organization
    true
  end
end
