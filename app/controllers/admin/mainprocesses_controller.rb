class Admin::MainprocessesController <  Admin::BaseController
  before_action :set_mainprocess, only: [:show, :edit, :update, :destroy]

  def index
    @mainprocesses = Mainprocess.all.page(params[:page])
  end

  def show
  end

  def new
    @mainprocess = Mainprocess.new
  end

  def edit
  end

  # POST /mainprocesses
  # POST /mainprocesses.json
  def create
    @mainprocess = Mainprocess.new(mainprocess_params)

    respond_to do |format|
      if @mainprocess.save
        redirect_to @mainprocess, notice: 'Mainprocess was successfully created.'
      else
        render :new
      end
    end
  end

  def update
    if @mainprocess.update(mainprocess_params)
      redirect_to @mainprocess, notice: 'Mainprocess was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @mainprocess.destroy
    redirect_to mainprocesses_url, notice: 'Mainprocess was successfully destroyed.'
  end

  private
    def set_mainprocess
      @mainprocess = Mainprocess.find(params[:id])
    end

    def mainprocess_params
      params.require(:mainprocess).permit(:orden, :descripcion)
    end
  end
