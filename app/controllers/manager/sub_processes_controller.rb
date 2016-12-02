class Manager::SubProcessesController < Manager::BaseController

  def index
    if params[:commit] == t("manager.sub_processes.index.submit")
      if params[:sub_processes].nil?
        main_process_id = params[:main_process_id]
      else
        main_process_id = params[:sub_processes][:main_process_id]
      end
      @sub_processes = SubProcess.where("main_process_id = ?", main_process_id).order(:unit_type_id, :order)
      @main_process = MainProcess.find(main_process_id)
      @period = @main_process.period
      @organization_type = @period.organization_type
      @unit_type_before = ""
    end
  end

  def show
  end

  def new
    @items = items_map(SubProcess.name.underscore)
    @main_process = MainProcess.find(params[:main_process_id])
    @period = @main_process.period
    initialize_vars
    @sub_process = SubProcess.new
  end

  def edit
    @sub_process  = SubProcess.find(params[:id])
    @item = @sub_process.item

    @main_process = @sub_process.main_process
    @period       = @sub_process.main_process.period
    initialize_vars
    @unit_type    = @sub_process.unit_type
    @items = items_map(SubProcess.name.underscore)
  end

  def create
    @items = items_map(SubProcess.name.underscore)
    @main_process = MainProcess.find(sub_process_params[:main_process_id])
    @period = @main_process.period
    initialize_vars
    @sub_process = SubProcess.new(sub_process_params)
    @sub_process.item_id = desc_to_item_id(params[:item_desc], SubProcess.name.underscore)
    @unit_types.find_by_description(params[:unit_type_desc]).description
    @sub_process.unit_type_id = desc_to_unit_type_id(params[:unit_type_desc])
    @sub_process.order = @sub_process.order.to_s.rjust(2, '0')  # => '05'
    @sub_process.updated_by = current_user.login
    it_task = Item.find_or_create_by(item_type: "task", description: "Tarea")
    if @sub_process.save
      @sub_process.tasks.find_or_create_by(item_id: it_task.id)
      redirect_to_index(t("manager.sub_processes.update.success"))
    else
      render :new
    end
  end

  def update
    if params[:commit]
      @items = items_map(SubProcess.name.underscore)
      @sub_process = SubProcess.find(params[:id])
      @sub_process.assign_attributes(sub_process_params)
      @sub_process.item_id = desc_to_item_id(params[:item_desc], SubProcess.name.underscore)

      @main_process = @sub_process.main_process
      @period = @main_process.period
      initialize_vars
      @sub_process.order = @sub_process.order.to_s.rjust(2, '0')  # => '05'
      @sub_process.updated_by = current_user.login
      if @sub_process.save
        redirect_to_index(t("manager.sub_processes.update.success"))
      else
        render :edit
      end
    end
  end

  def destroy
   @sub_process = SubProcess.find(params[:id])
   @main_process = @sub_process.main_process
   @period = @main_process.period

   if @sub_process.destroy
     msg = t("manager.sub_processes.destroy.success")
   else
     msg = t("manager.sub_processes.destroy.error")
   end
    redirect_to_index(msg)
  end

  private
    def sub_process_params
      params.require(:sub_process).permit(:main_process_id, :item_id, :order, :unit_type_id, :updated_by)
    end

    def redirect_to_index(msg)
     redirect_to manager_sub_processes_path(commit: t("manager.sub_processes.index.submit"),
       main_process_id: @sub_process.main_process_id,
       period_id: @period.id, organization_type_id: @period.organization_type_id,
       modifiable: @period.modifiable?, eliminable: @period.eliminable?),
       notice: msg
    end

    def initialize_vars
      @organization_type = @period.organization_type
      @unit_types  = @organization_type.unit_types.order(:order)

    end
end
