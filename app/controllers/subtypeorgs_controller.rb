class SubtypeorgsController < ApplicationController
  before_action :set_subtypeorg, only: [:show, :edit, :update, :destroy]

  # GET /subtypeorgs
  # GET /subtypeorgs.json
  def index
    @subtypeorgs = Subtypeorg.all
  end

  # GET /subtypeorgs/1
  # GET /subtypeorgs/1.json
  def show
  end

  # GET /subtypeorgs/new
  def new
    @subtypeorg = Subtypeorg.new
  end

  # GET /subtypeorgs/1/edit
  def edit
  end

  # POST /subtypeorgs
  # POST /subtypeorgs.json
  def create
    @subtypeorg = Subtypeorg.new(subtypeorg_params)

    respond_to do |format|
      if @subtypeorg.save
        format.html { redirect_to @subtypeorg, notice: 'Subtypeorg was successfully created.' }
        format.json { render :show, status: :created, location: @subtypeorg }
      else
        format.html { render :new }
        format.json { render json: @subtypeorg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subtypeorgs/1
  # PATCH/PUT /subtypeorgs/1.json
  def update
    respond_to do |format|
      if @subtypeorg.update(subtypeorg_params)
        format.html { redirect_to @subtypeorg, notice: 'Subtypeorg was successfully updated.' }
        format.json { render :show, status: :ok, location: @subtypeorg }
      else
        format.html { render :edit }
        format.json { render json: @subtypeorg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subtypeorgs/1
  # DELETE /subtypeorgs/1.json
  def destroy
    @subtypeorg.destroy
    respond_to do |format|
      format.html { redirect_to subtypeorgs_url, notice: 'Subtypeorg was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subtypeorg
      @subtypeorg = Subtypeorg.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subtypeorg_params
      params.fetch(:subtypeorg, {})
    end
end
