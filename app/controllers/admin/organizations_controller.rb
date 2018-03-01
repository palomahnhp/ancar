class Admin::OrganizationsController < Admin::BaseController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  def index
    @organizations = Organization.all
  end

  def show
  end

  def new
    @organization = Organization.new
  end

  def edit
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      redirect_to admin_organizations_path, notice: 'Organization type was successfully created.'
    else
      render :new
    end
  end

  def update
    if @organization.update(organization_params)
      redirect_to admin_organizations_path, notice: t('admin.actions.update')
    else
      render :edit
    end
  end

  def destroy
    if check_destroy
      @organization.destroy
      message = 'Organización eliminada.'
    else
      message = 'No se puede eliminar ya que tiene objetas asignadas.'
    end
    redirect_to admin_organizations_path, notice: message
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:description, :short_description, :sap_id, :organization_type_id, :order)
  end

  def check_destroy
    return false if @organization.units ||
                    @organization.users ||
                    @organization.main_processes ||
                    @organization.budget_programs ||
                    @organization.rpts ||
                    @organization.unit_rpt_assignations
    true
  end
end
