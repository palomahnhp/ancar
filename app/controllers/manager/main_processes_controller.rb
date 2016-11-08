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
      @period = Period.find(period_id)
      @organization_type = OrganizationType.find(organization_type_id)
    end
  end

  def show
  end

  def new
    @items = items_map(MainProcess.name.underscore)
    @organization_type = OrganizationType.find(params[:organization_type_id])
    @period = Period.find(params[:period_id])
    @main_process = MainProcess.new
  end

  def edit
    @items = items_map(MainProcess.name.underscore)
    @main_process = MainProcess.find(params[:id])
    @item = @main_process.item
    @period = @main_process.period
    if params[:commit]
      @main_process.item_id = desc_to_item_id(params[:item_desc], MainProcess.name.underscore)
      @main_process.order = params[:order]
      if @main_process.save
        redirect_to_index(t("manager.main_processes.update.success"))
      else
        render :edit
      end
    end
  end

  def create
    @items = items_map(MainProcess.name.underscore)
    @period = Period.find(main_process_params[:period_id])
    @organization_type = @period.organization_type

    @main_process = MainProcess.new(main_process_params)
    @main_process.item_id = desc_to_item_id(params[:item_desc], MainProcess.name.underscore)
    if @main_process.save
      redirect_to_index(t("manager.main_processes.create.success"))
    else
      render :new
    end
  end

  def update
    if params[:commit]
      @items = items_map(MainProcess.name.underscore)
      @main_process = MainProcess.find(params[:id])
      @main_process.assign_attributes(main_process_params)
      @period = @main_process.period
      @main_process.item_id = desc_to_item_id(params[:item_desc], MainProcess.name.underscore)
      if @main_process.save
        redirect_to_index(t("manager.main_processes.update.success"))
      else
        render :edit
      end
    end
  end

  def destroy
   @main_process = MainProcess.find(params[:id])
   @period = @main_process.period
   if @main_process.destroy
     msg = t("manager.main_processes.destroy.success")
   else
     msg = t("manager.main_processes.destroy.error")
   end
     redirect_to_index(msg)
  end

  private
    def main_process_params
      params.require(:main_process).permit(:period_id, :item_id, :order)
    end

    def redirect_to_index(msg)
      redirect_to manager_main_processes_path(commit: t("manager.main_processes.index.submit"),
           period_id: @period.id, organization_type_id: @period.organization_type_id,
           modifiable: @period.modifiable?, eliminable: @period.eliminable?),
           notice: msg
    end
end
