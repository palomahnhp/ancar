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
      @main_processes = MainProcess.where("period_id = ?", period_id).order(:order)
      @organization_type = OrganizationType.find(organization_type_id)
      @period = Period.find(period_id)
    end
  end

  def new
    @items = Item.where(item_type: "main_process")
    @organization_type = OrganizationType.find(params[:organization_type_id])
    @period = Period.find(params[:period_id])
    @main_process = MainProcess.new
  end

  def create
    @main_process = MainProcess.new(main_process_params)
    if @main_process.save
      redirect_to manager_periods_path
    else
      render :new
    end
  end

  def edit
    @items = Item.where(item_type: 'main_process').order(:description).map{|item| [item.description, item.id]}
    @main_process = MainProcess.find(params[:id])
    @period = @main_process.period
    if params[:commit]
      @main_process.item_id = desc_to_item_id(params[:item_desc], Process.name.underscore)
      @main_process.order = params[:order]
      if @main_process.save
        redirect_to manager_main_processes_path(commit: t("manager.main_processes.index.submit"), period_id: @period.id, organization_type_id: @period.organization_type_id)
      else
        render :edit
      end
    end
  end

  def update
    if @main_process.update
      redirect_to manager_main_processes_path
    else
      render :edit
    end
  end

  def show
   @main_process = MainProcess.find(params[:id])
  end

  def destroy
     if @main_process.destroy_all
       msg = t("manager.main_processes.index.destroy.success")
     else
       msg = t("manager.main_processes.index.destroy.error")
     end
     redirect_to manager_main_processes_path, notice: msg
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
