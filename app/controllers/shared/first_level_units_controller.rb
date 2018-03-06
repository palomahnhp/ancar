class Shared::FirstLevelUnitsController < ApplicationController
  before_action :set_first_level_unit, only: [:show, :edit, :update, :destroy]

  # GET /first_level_units
  # GET /first_level_units.json
  def index
    @first_level_units = FirstLevelUnit.active
  end

  # GET /first_level_units/1
  # GET /first_level_units/1.json
  def show
  end

  # GET /first_level_units/new
  def new
    @first_level_unit = FirstLevelUnit.new
  end

  # GET /first_level_units/1/edit
  def edit
  end

  # POST /first_level_units
  # POST /first_level_units.json
  def create
    @first_level_unit = FirstLevelUnit.new(first_level_unit_params)

    respond_to do |format|
      if @first_level_unit.save
        format.html { redirect_to @first_level_unit, notice: 'First level unit was successfully created.' }
        format.json { render :show, status: :created, location: @first_level_unit }
      else
        format.html { render :new }
        format.json { render json: @first_level_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /first_level_units/1
  # PATCH/PUT /first_level_units/1.json
  def update
    respond_to do |format|
      if @first_level_unit.update(first_level_unit_params)
        format.html { redirect_to @first_level_unit, notice: 'First level unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @first_level_unit }
      else
        format.html { render :edit }
        format.json { render json: @first_level_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /first_level_units/1
  # DELETE /first_level_units/1.json
  def destroy
    @first_level_unit.destroy
    respond_to do |format|
      format.html { redirect_to first_level_units_url, notice: 'First level unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if FirstLevelUnit.import(params[:file])
      message = "Fichero importado."
    else
      message = "Error en la importación."
    end
    redirect_to admin_first_level_units_path, notice: message
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_first_level_unit
      @first_level_unit = FirstLevelUnit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def first_level_unit_params
      params.fetch(:first_level_unit, {})
    end
end
