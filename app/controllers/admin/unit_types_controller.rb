class Admin::UnitTypesController < Admin::BaseController
  before_action :set_admin_unit_type, only: [:show, :edit, :update, :destroy]

  # GET /admin/unit_types
  # GET /admin/unit_types.json
  def index
    @admin_unit_types = Admin::UnitType.all
  end

  # GET /admin/unit_types/1
  # GET /admin/unit_types/1.json
  def show
  end

  # GET /admin/unit_types/new
  def new
    @admin_unit_type = Admin::UnitType.new
  end

  # GET /admin/unit_types/1/edit
  def edit
  end

  # POST /admin/unit_types
  # POST /admin/unit_types.json
  def create
    @admin_unit_type = Admin::UnitType.new(admin_unit_type_params)

    respond_to do |format|
      if @admin_unit_type.save
        format.html { redirect_to @admin_unit_type, notice: 'Unit type was successfully created.' }
        format.json { render :show, status: :created, location: @admin_unit_type }
      else
        format.html { render :new }
        format.json { render json: @admin_unit_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/unit_types/1
  # PATCH/PUT /admin/unit_types/1.json
  def update
    respond_to do |format|
      if @admin_unit_type.update(admin_unit_type_params)
        format.html { redirect_to @admin_unit_type, notice: 'Unit type was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_unit_type }
      else
        format.html { render :edit }
        format.json { render json: @admin_unit_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/unit_types/1
  # DELETE /admin/unit_types/1.json
  def destroy
    @admin_unit_type.destroy
    respond_to do |format|
      format.html { redirect_to admin_unit_types_url, notice: 'Unit type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_unit_type
      @admin_unit_type = Admin::UnitType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_unit_type_params
      params.fetch(:admin_unit_type, {})
    end
end
