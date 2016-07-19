class EntryIndicatorsController < ApplicationController
  before_action :set_entry_indicator, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:index, :show]

  # GET /entry_indicators
  # GET /entry_indicators.json
  def index
    if !current_user.has_organizations?
      puts "Sin unidad"
      redirect_to root_path, notice: 'No tiene autorizada la consulta de datos de ninguna unidad'
    end

    if current_user.organizations_unique?  || !params[:organization_id].nil?
      organization_id = params[:organization_id].nil? ? current_user.organizations.take.id : params[:organization_id]
      @organization = Organization.find(organization_id)
      @organization_type = @organization.organization_type
      @period = @organization_type.periods.last
      @units = @organization.units.order(:order).to_a
      @main_processes = MainProcess.where(period_id: @period.id).order(:order)

      if params[:unit]
        @unit = Unit.find(params[:unit])
      else
        @unit = @units.first
      end
      @official_groups = OfficialGroup.all

    else
      @select_organizations = organizations_select_options
    end
  end

  def new
    @entry_indicator = EntryIndicator.new
  end

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

  def destroy
    @entry_indicator.destroy
    respond_to do |format|
      format.html { redirect_to entry_indicators_url, notice: 'Entry indicator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_entry_indicator
      @entry_indicator = EntryIndicator.find(params[:id])
    end

    def entry_indicator_params
      params.fetch(:entry_indicator, {})
    end

    def organizations_select_options
      current_user.auth_organizations.collect { |v| [ v.description, v.id ] }
    end

end
