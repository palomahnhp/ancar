class Admin::UnitsController < Admin::BaseController
  before_action :set_admin_unit, only: [:show, :edit, :update, :destroy]

  # GET /admin/units
  # GET /admin/units.json
  def index
    @admin_units = Admin::Unit.all
  end

  # GET /admin/units/1
  # GET /admin/units/1.json
  def show
  end

  # GET /admin/units/new
  def new
    @admin_unit = Admin::Unit.new
  end

  # GET /admin/units/1/edit
  def edit
  end

  # POST /admin/units
  # POST /admin/units.json
  def create
    @admin_unit = Admin::Unit.new(admin_unit_params)

    respond_to do |format|
      if @admin_unit.save
        format.html { redirect_to @admin_unit, notice: 'Unit was successfully created.' }
        format.json { render :show, status: :created, location: @admin_unit }
      else
        format.html { render :new }
        format.json { render json: @admin_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/units/1
  # PATCH/PUT /admin/units/1.json
  def update
    respond_to do |format|
      if @admin_unit.update(admin_unit_params)
        format.html { redirect_to @admin_unit, notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_unit }
      else
        format.html { render :edit }
        format.json { render json: @admin_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/units/1
  # DELETE /admin/units/1.json
  def destroy
    @admin_unit.destroy
    respond_to do |format|
      format.html { redirect_to admin_units_url, notice: 'Unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_unit
      @admin_unit = Admin::Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_unit_params
      params.fetch(:admin_unit, {})
    end
end
