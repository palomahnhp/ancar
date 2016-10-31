class Manager::TasksController < Manager::BaseController

  def index
    if params[:commit] == t("manager.tasks.index.submit")
      if params[:tasks].nil?
        sub_process_id = params[:sub_process_id]
      else
        sub_process_id = params[:tasks][:sub_process_id]
      end

      @tasks = Task.where("sub_process_id = ?", sub_process_id)
      @sub_process = SubProcess.find(sub_process_id)
      @main_process = MainProcess.find(@sub_process.main_process_id)
      @period = Period.find(@main_process.period_id)
      @organization_type = OrganizationType.find(@period.organization_type_id)
    end
      @organization_types = OrganizationType.all
      @periods = Period.where("organization_type_id = ?", OrganizationType.first.id)
      @main_processes = MainProcess.where("period_id = ?", @periods.first.id)
      @sub_processes = SubProcess.where("main_process_id = ?", @main_processes.first.id)
  end

  def show
    @task = Task.find_by("id = ?", params[:sub_process])
  end

  def edit
    @items = Item.where(item_type: Task.class.name.underscore).order(:description).map{|item| [item.description, item.id]}
    @task  = Task.find(params[:id])
    @sub_process  = @task.sub_process
    @unit_type    = @sub_process.unit_type #UnitType.find(@sub_process.unit_type_id)
    @main_process = @sub_process.main_process #MainProcess.find(@sub_process.main_process_id)
    @period       = @sub_process.main_process.period
    @organization_type = OrganizationType.find(@unit_type.organization_type_id)
    @unit_types   = UnitType.where(organization_type_id: @organization_type.id).order(:order)
    if params[:commit]
      @task.item_id = desc_to_item_id(params[:item_desc], Tasks.name.underscore)
      @task.order = params[:order]
      if @task.save
        redirect_to manager_tasks_path(commit: t("manager.tasks.index.submit"),
           sub_process_id: @task.sub_process_id,
           main_process_id: @task.sub_process.main_process_id,
           period_id: @period.id, organization_type_id: @period.organization_type_id)
      else
        render :edit
      end
    end
  end

  def destroy
     if @task.destroy_all
       msg = t("manager.tasks.index.destroy.success")
     else
       msg = t("manager.tasks.index.destroy.error")
     end
     redirect_to manager_task_path, notice: msg
  end

private
  def item_new(description)
    Item.create(item_type: SubProcess.class.name.underscore, description: description).id
  end

end
