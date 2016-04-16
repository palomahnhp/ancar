class Admin::OrganizationTypesController < Admin::BaseController
  before_action :set_admin_organization_type, only: [:show, :edit, :update, :destroy]

  # GET /admin/organization_types
  # GET /admin/organization_types.json
  def index
    @admin_organization_types = Admin::OrganizationType.all
  end

  # GET /admin/organization_types/1
  # GET /admin/organization_types/1.json
  def show
  end

  # GET /admin/organization_types/new
  def new
    @admin_organization_type = Admin::OrganizationType.new
  end

  # GET /admin/organization_types/1/edit
  def edit
  end

  # POST /admin/organization_types
  # POST /admin/organization_types.json
  def create
    @admin_organization_type = Admin::OrganizationType.new(admin_organization_type_params)

    respond_to do |format|
      if @admin_organization_type.save
        format.html { redirect_to @admin_organization_type, notice: 'Organization type was successfully created.' }
        format.json { render :show, status: :created, location: @admin_organization_type }
      else
        format.html { render :new }
        format.json { render json: @admin_organization_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/organization_types/1
  # PATCH/PUT /admin/organization_types/1.json
  def update
    respond_to do |format|
      if @admin_organization_type.update(admin_organization_type_params)
        format.html { redirect_to @admin_organization_type, notice: 'Organization type was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_organization_type }
      else
        format.html { render :edit }
        format.json { render json: @admin_organization_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/organization_types/1
  # DELETE /admin/organization_types/1.json
  def destroy
    @admin_organization_type.destroy
    respond_to do |format|
      format.html { redirect_to admin_organization_types_url, notice: 'Organization type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_organization_type
      @admin_organization_type = Admin::OrganizationType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_organization_type_params
      params.fetch(:admin_organization_type, {})
    end
end
