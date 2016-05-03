class Admin::MainProcessesController < Admin::BaseController

  def index
    if params[:commit] == t("admin.main_processes.index.submit")
      if params[:main_processes].nil?
          period_id = params[:period_id]
          organization_type_id = params[:organization_type_id]
      else
          period_id =  params[:main_processes][:period_id]
          organization_type_id = params[:main_processes][:organization_type_id]
      end
      @main_processes = MainProcess.where("period_id = ?", period_id)
      @organization_type = OrganizationType.find(organization_type_id)
      @period = Period.find(period_id)
    end
      @organization_types = OrganizationType.all
      @periods = Period.where("organization_type_id = ?", OrganizationType.first.id)
  end

  def new
    @items = Item.where(item_type: "main_process")
    @organization_type = OrganizationType.find(params[:organization_type_id])
    @period = Period.find(params[:period_id])
    @main_process = MainProcess.new
  end

  def create
    debugger
    @main_process = MainProcess.new(main_process_params)
    if @main_process.save
      redirect_to admin_main_processes_path
    else
      render :new
    end
  end

  def show
    @main_process = MainProcess.find_by("id = ?", params[:organization][:period])
  end

  def update_period
    @periods = Period.where("organization_type_id = ?", params[:organization_type_id])
    respond_to do |format|
      format.js
    end
  end

  private
    def main_process_params
      params.require(:main_process).permit(:period_id, :item_id, :order)
    end

    def find_main_process
      @main_process = MainProcess.find(params[:id])
    end

    def find_references
      @organization_types = OrganizationType.all.map { |org| [org.name, org.id] }
#      @periods = Period.where(organization_type_id: type.id).map { |period| [period.name, period.id] }
    end
end
