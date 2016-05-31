class EntryIndicatorsController < ApplicationController
  before_action :set_entry_indicator, only: [:show, :edit, :update, :destroy]

  # GET /entry_indicators
  # GET /entry_indicators.json
  def index
    # La organization se debe obtener del user, Utilizamos VillaVallecas para comprobaciones carga
    distritos = 1

    @organization = OrganizationType.find(distritos).organizations.find(20)
    # de la organización el tipo de organizacion
    @organization_type = @organization.organization_type
    # el periodo es el activo para ese tipo de organización
    @period = @organization_type.periods.first
    @units = @organization.units.to_a
    # no funciona la recuperación del periodo
    @main_processes = MainProcess.where(period_id: @period.id)
    if params[:unit]
      @unit = Unit.find(params[:unit])
    else
      @unit = @units.first
    end
    @official_groups = OfficialGroup.all
    # totalizadores para comprobaciones de carga

    mp = @main_processes.ids
    sp = SubProcess.where(main_process_id: mp, unit_type_id: @unit.unit_type.id)

    @total_sub_processes  = sp.count
    @total_main_processes = sp.where(main_process_id: mp).distinct.count

    @total_staff_sub_process_A1 = AssignedEmployee.where(staff_of_type: "SubProcess", staff_of_id: sp,
      official_groups_id: 1).sum(:quantity)
    @total_staff_sub_process_A2 = AssignedEmployee.where(staff_of_type: "SubProcess", staff_of_id: sp,
      official_groups_id: 2).sum(:quantity)
    @total_staff_sub_process_C1 = AssignedEmployee.where(staff_of_type: "SubProcess", staff_of_id: sp,
      official_groups_id: 3).sum(:quantity)
    @total_staff_sub_process_C2 = AssignedEmployee.where(staff_of_type: "SubProcess", staff_of_id: sp,
      official_groups_id: 4).sum(:quantity)
    @total_staff_sub_process_E  = AssignedEmployee.where(staff_of_type: "SubProcess", staff_of_id: sp,
      official_groups_id: 5).sum(:quantity)
  end

  # GET /entry_indicators/1
  # GET /entry_indicators/1.json_processes.unit_
  def show
  end

  # GET /entry_indicators/new
  def new
    @entry_indicator = EntryIndicator.new
  end

  # GET /entry_indicators/1/edit
  def edit
  end

  # POST /entry_indicators
  # POST /entry_indicators.json
  def create
    @entry_indicator = EntryIndicator.new(entry_indicator_params)

    respond_to do |format|
      if @entry_indicator.save
        format.html { redirect_to @entry_indicator, notice: 'Entry indicator was successfully created.' }
        format.json { render :show, status: :created, location: @entry_indicator }
      else
        format.html { render :new }
        format.json { render json: @entry_indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entry_indicators/1
  # PATCH/PUT /entry_indicators/1.json
  def update
    respond_to do |format|
      if @entry_indicator.update(entry_indicator_params)
        format.html { redirect_to @entry_indicator, notice: 'Entry indicator was successfully updated.' }
        format.json { render :show, status: :ok, location: @entry_indicator }
      else
        format.html { render :edit }
        format.json { render json: @entry_indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entry_indicators/1
  # DELETE /entry_indicators/1.json
  def destroy
    @entry_indicator.destroy
    respond_to do |format|
      format.html { redirect_to entry_indicators_url, notice: 'Entry indicator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry_indicator
      @entry_indicator = EntryIndicator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_indicator_params
      params.fetch(:entry_indicator, {})
    end
end
