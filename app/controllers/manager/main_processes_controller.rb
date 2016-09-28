class Manager::MainProcessesController < Manager::BaseController

  def index
    if params[:commit] == t("manager.main_processes.index.submit")
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
#      @organization_types = OrganizationType.all
#      @periods = Period.where("organization_type_id = ?", OrganizationType.first.id)
  end

  def new
    redirect_to in_works_path, alert: "Opción no disponible. Lo estará proximamente"
    @items = Item.where(item_type: "main_process")
    @organization_type = OrganizationType.find(params[:organization_type_id])
    @period = Period.find(params[:period_id])
    @main_process = MainProcess.new
  end

  def create
    @main_process = MainProcess.new(main_process_params)
    if @main_process.save
      redirect_to admin_root_path
    else
      render :new
    end
  end

  def edit
     # Aun no está listo para subi a Pro
    redirect_to in_works_path, alert: "Opción no disponible. Lo estará proximamente"
    period_id = params[:period_id]
    organization_type_id = params[:organization_type_id]
    @main_processes = MainProcess.where("period_id = ?", period_id)
    @organization_type = OrganizationType.find(organization_type_id)
    @period = Period.find(period_id)
  end


  def show
   @main_process = MainProcess.find(params[:id])
  end

  def update_period
    @periods = Period.where("organization_type_id = ?", params[:organization_type_id])
    respond_to do |format|
      format.js
    end
  end

  def destroy
     # Aun no está listo para subi a Pro
    redirect_to in_works_path, alert: "Opción no disponible. Lo estará proximamente"

    # main_process = MainProcess.find(params[:id])

    # if main_process.destroy_all
    #   msg = t("manager.main_processes.index.destroy.success")
    # else
    #   msg = t("manager.main_processes.index.destroy.error")
    # end
    # redirect_to manager_main_processes_path, notice: msg
  end

  private
    def main_process_params
      params.require(:main_process).permit(:period_id, :item_id, :order)
    end

    def find_main_process
      @main_process = MainProcess.find(params[:id])
    end

    def find_references
      @organization_types = OrganizationType.all.map { |org| [org.description, org.id] }
#      @periods = Period.where(organization_type_id: type.id).map { |period| [period.description, period.id] }
    end
end
