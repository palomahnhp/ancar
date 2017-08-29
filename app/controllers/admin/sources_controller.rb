class Admin::SourcesController < Admin::BaseController
  before_action :set_source, only: [:show, :edit, :update, :destroy]

  def index
    @sources = Source.all.order(:id)
  end

  def show
  end

  def new
    @source = Source.new
  end

  def edit
  end

  def create
    @source = Source.new(source_params)
    respond_to do |format|
      if @source.save
        format.html { redirect_to @source, notice: t('admin.sources.create.success') }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /admin/sources/1
  # PATCH/PUT /admin/sources/1.json
  def update
    respond_to do |format|
      @source.item.description = params[:description]
      if @source.update(source_params)
        format.html { redirect_to [:admin, @source], notice: 'Source was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end


  def destroy
    @source.destroy
    respond_to do |format|
      format.html { redirect_to admin_sources_url, notice: 'Source was successfully destroyed.' }
    end
  end

  private

    def set_source
      @source = Source.find(params[:id])
    end
# TODO add nested attributes items
    def source_params
      params.require(:source).permit(:fixed, :has_specification, :active, :organization_type_id)
    end
end
