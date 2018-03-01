class Admin::OrganizationTypesController < Admin::BaseController
  before_action :set_organization_type, only: [:show, :edit, :update, :destroy]
  def index
    @organization_types = OrganizationType.all
  end

  def show
  end

  def new
    @organization_type = OrganizationType.new
  end

  def edit
  end

  def create
    @organization_type = OrganizationType.new(organization_type_params)
    if @organization_type.save
      redirect_to admin_organization_types_path, notice: 'Organization type was successfully created.'
    else
      render :new
    end
  end

  def update
    if @organization_type.update(organization_type_params)
      redirect_to admin_organization_types_path, notice: t('admin.actions.update')
    else
      render :edit
    end
  end

  def destroy
    if check_destroy
      @organization_type.destroy
      message = 'Organization type was successfully destroyed.'
    else
      message = 'No se puede eliminar ya que tiene Unidades asignadas.'
    end
    redirect_to admin_organization_types_path, notice: message
  end

  private

    def set_organization_type
      @organization_type = OrganizationType.find(params[:id])
    end

    def organization_type_params
      params.require(:organization_type).permit(:description, :acronym)
    end

    def check_destroy
      return false if @organization_type.organizations ||
                     @organization_type.periods       ||
                     @organization_type.unit_types    ||
                     @organization_type.main_processes ||
                     @organization_type.process_names

      errors.add :base, "No se puede eliminar: tipo de organización tiene relaciones con otros objetos"
      true
    end
end
