class MainprocessesController < ApplicationController
  before_action :set_mainprocess, only: [:show, :edit, :update, :destroy]

  # GET /mainprocesses
  # GET /mainprocesses.json
  def index
    @mainprocesses = Mainprocess.all
  end

  # GET /mainprocesses/1
  # GET /mainprocesses/1.json
  def show
  end

  # GET /mainprocesses/new
  def new
    @mainprocess = Mainprocess.new
  end

  # GET /mainprocesses/1/edit
  def edit
  end

  # POST /mainprocesses
  # POST /mainprocesses.json
  def create
    @mainprocess = Mainprocess.new(mainprocess_params)

    respond_to do |format|
      if @mainprocess.save
        format.html { redirect_to @mainprocess, notice: 'Mainprocess was successfully created.' }
        format.json { render :show, status: :created, location: @mainprocess }
      else
        format.html { render :new }
        format.json { render json: @mainprocess.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mainprocesses/1
  # PATCH/PUT /mainprocesses/1.json
  def update
    respond_to do |format|
      if @mainprocess.update(mainprocess_params)
        format.html { redirect_to @mainprocess, notice: 'Mainprocess was successfully updated.' }
        format.json { render :show, status: :ok, location: @mainprocess }
      else
        format.html { render :edit }
        format.json { render json: @mainprocess.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mainprocesses/1
  # DELETE /mainprocesses/1.json
  def destroy
    @mainprocess.destroy
    respond_to do |format|
      format.html { redirect_to mainprocesses_url, notice: 'Mainprocess was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mainprocess
      @mainprocess = Mainprocess.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mainprocess_params
      params.fetch(:mainprocess, {})
    end
end
