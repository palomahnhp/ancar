class OutputIndicatorsController < ApplicationController
  before_action :set_output_indicator, only: [:show, :edit, :update, :destroy]

  # GET /output_indicators
  # GET /output_indicators.json
  def index
    @output_indicators = OutputIndicator.all
  end

  # GET /output_indicators/1
  # GET /output_indicators/1.json
  def show
  end

  # GET /output_indicators/new
  def new
    @output_indicator = OutputIndicator.new
  end

  # GET /output_indicators/1/edit
  def edit
  end

  # POST /output_indicators
  # POST /output_indicators.json
  def create
    @output_indicator = OutputIndicator.new(output_indicator_params)

    respond_to do |format|
      if @output_indicator.save
        format.html { redirect_to @output_indicator, notice: 'Output indicator was successfully created.' }
        format.json { render :show, status: :created, location: @output_indicator }
      else
        format.html { render :new }
        format.json { render json: @output_indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /output_indicators/1
  # PATCH/PUT /output_indicators/1.json
  def update
    respond_to do |format|
      if @output_indicator.update(output_indicator_params)
        format.html { redirect_to @output_indicator, notice: 'Output indicator was successfully updated.' }
        format.json { render :show, status: :ok, location: @output_indicator }
      else
        format.html { render :edit }
        format.json { render json: @output_indicator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /output_indicators/1
  # DELETE /output_indicators/1.json
  def destroy
    @output_indicator.destroy
    respond_to do |format|
      format.html { redirect_to output_indicators_url, notice: 'Output indicator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_output_indicator
      @output_indicator = OutputIndicator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def output_indicator_params
      params.fetch(:output_indicator, {})
    end
end
