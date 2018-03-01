class Admin::UnitTypesController < Admin::BaseController
    before_action :set_unit_type, only: [:show, :edit, :update, :destroy]

    def index
      @unit_types = UnitType.all
    end

    def show
    end

    def new
      @unit_type = Unit_type.new
    end

    def edit
    end

    def create
      @unit_type = UnitType.new(unit_type_params)
      if @unit_type.save
        redirect_to admin_unit_types_path, notice: 'Organization type was successfully created.'
      else
        render :new
      end
    end

    def update
      if @unit_type.update(unit_type_params)
        redirect_to admin_unit_types_path, notice: t('admin.actions.update')
      else
        render :edit
      end
    end

    def destroy
      if check_destroy
        redirect_to admin_unit_types_path, notice: 'Organization type was successfully destroyed.'
        @unit_type.destroy
        message = 'Tipo de unidad eliminado.'
      else
        message = 'No se puede eliminar ya que tiene Unidades asignadas.'
      end
      redirect_to admin_organization_types_path, notice: message
    end

    private

    def set_unit_type
      @unit_type = UnitType.find(params[:id])
    end

    def unit_type_params
      params.require(:unit_type).permit(:description, :order, :organization_type_id)
    end
end
