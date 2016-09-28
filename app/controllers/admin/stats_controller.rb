class StatsController  < Admin::BaseController
  before_action :set_stat, only: [:show, :edit, :update, :destroy]

  def index
     @stats = Stat.all
  end

  def show
  end

  def new
    @stat = Stat.new
  end

  def edit
  end

  def create
    @stat = Stat.new(stat_params)
    if @stat.save
      redirect_to @stat, notice: 'Stat was successfully created.'
    else
      render :new
    end
  end

  def update
    if @stat.update(stat_params)
      redirect_to @stat, notice: 'Stat was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @stat.destroy
    redirect_to stats_url, notice: 'Stat was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stat
      @stat = Stat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stat_params
      params.fetch(:stat, {})
    end
end
