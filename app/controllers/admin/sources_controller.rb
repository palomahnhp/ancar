class Admin::SourcesController < Admin::BaseController
  before_action :set_source, only: [:show, :edit, :update, :destroy]

  # GET /admin/sources
  # GET /admin/sources.json
  def index
    @sources = Source.all.order(:id)
  end

  # GET /admin/sources/1
  # GET /admin/sources/1.json
  def show
  end

  # GET /admin/sources/new
  def new
    @source = Source.new
  end

  # GET /admin/sources/1/edit
  def edit
  end

  # POST /admin/sources
  # POST /admin/sources.json
  def create
    @source = Source.new(source_params)

    respond_to do |format|
      if @source.save
        format.html { redirect_to @source, notice: 'Source was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /admin/sources/1
  # PATCH/PUT /admin/sources/1.json
  def update
    respond_to do |format|
      if @source.update(source_params)
        format.html { redirect_to @source, notice: 'Source was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /admin/sources/1
  # DELETE /admin/sources/1.json
  def destroy
    @source.destroy
    respond_to do |format|
      format.html { redirect_to admin_sources_url, notice: 'Source was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_source
      @source = Source.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def source_params
      params.fetch(:admin_source, {})
    end
end
