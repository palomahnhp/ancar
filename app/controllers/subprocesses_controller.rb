class SubprocessesController < ApplicationController
  before_action :set_subprocess, only: [:show, :edit, :update, :destroy]

  # GET /subprocesses
  # GET /subprocesses.json
  def index
    @subprocesses = Subprocess.all
  end

  # GET /subprocesses/1
  # GET /subprocesses/1.json
  def show
  end

  # GET /subprocesses/new
  def new
    @subprocess = Subprocess.new
  end

  # GET /subprocesses/1/edit
  def edit
  end

  # POST /subprocesses
  # POST /subprocesses.json
  def create
    @subprocess = Subprocess.new(subprocess_params)

    respond_to do |format|
      if @subprocess.save
        format.html { redirect_to @subprocess, notice: 'Subprocess was successfully created.' }
        format.json { render :show, status: :created, location: @subprocess }
      else
        format.html { render :new }
        format.json { render json: @subprocess.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subprocesses/1
  # PATCH/PUT /subprocesses/1.json
  def update
    respond_to do |format|
      if @subprocess.update(subprocess_params)
        format.html { redirect_to @subprocess, notice: 'Subprocess was successfully updated.' }
        format.json { render :show, status: :ok, location: @subprocess }
      else
        format.html { render :edit }
        format.json { render json: @subprocess.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subprocesses/1
  # DELETE /subprocesses/1.json
  def destroy
    @subprocess.destroy
    respond_to do |format|
      format.html { redirect_to subprocesses_url, notice: 'Subprocess was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subprocess
      @subprocess = Subprocess.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subprocess_params
      params.fetch(:subprocess, {})
    end
end
