class Admin::OrganizationTypesController < Admin::BaseController
  before_action :set_admin_organization_type, only: [:show, :edit, :update, :destroy]

  def index
    @admin_organization_types = OrganizationType.all
  end

  def show
  end

  def new
    @admin_organization_type = OrganizationType.new
  end

  def edit
  end

  def create
    @admin_organization_type = OrganizationType.new(admin_organization_type_params)
    if @admin_organization_type.save
      redirect_to @admin_organization_type, notice: 'Organization type was successfully created.'
    else
      render :new
    end
  end

  def update
    if @admin_organization_type.update(admin_organization_type_params)
      redirect_to @admin_organization_type, notice: 'Organization type was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @admin_organization_type.destroy
    redirect_to admin_organization_types_url, notice: 'Organization type was successfully destroyed.'
  end

  private

    def set_admin_organization_type
      @admin_organization_type = Admin::OrganizationType.find(params[:id])
    end

    def admin_organization_type_params
      params.fetch(:admin_organization_type, {})
    end
end
