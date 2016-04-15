class TypeorgsController < ApplicationController
  before_action :set_typeorg, only: [:show, :edit, :update, :destroy]

  # GET /typeorgs
  # GET /typeorgs.json
  def index
    @typeorgs = Typeorg.all
  end

  # GET /typeorgs/1
  # GET /typeorgs/1.json
  def show
  end

  # GET /typeorgs/new
  def new
    @typeorg = Typeorg.new
  end

  # GET /typeorgs/1/edit
  def edit
  end

  # POST /typeorgs
  # POST /typeorgs.json
  def create
    @typeorg = Typeorg.new(typeorg_params)

    respond_to do |format|
      if @typeorg.save
        format.html { redirect_to @typeorg, notice: 'Typeorg was successfully created.' }
        format.json { render :show, status: :created, location: @typeorg }
      else
        format.html { render :new }
        format.json { render json: @typeorg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /typeorgs/1
  # PATCH/PUT /typeorgs/1.json
  def update
    respond_to do |format|
      if @typeorg.update(typeorg_params)
        format.html { redirect_to @typeorg, notice: 'Typeorg was successfully updated.' }
        format.json { render :show, status: :ok, location: @typeorg }
      else
        format.html { render :edit }
        format.json { render json: @typeorg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /typeorgs/1
  # DELETE /typeorgs/1.json
  def destroy
    @typeorg.destroy
    respond_to do |format|
      format.html { redirect_to typeorgs_url, notice: 'Typeorg was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_typeorg
      @typeorg = Typeorg.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def typeorg_params
      params.fetch(:typeorg, {})
    end
end
