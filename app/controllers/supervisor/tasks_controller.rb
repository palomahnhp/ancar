class Supervisor::TasksController < Supervisor::BaseController

  def index
    if params[:commit] == t('supervisor.tasks.index.submit')
      sub_process_id = params[:sub_process_id]
      @tasks = Task.where('sub_process_id = ?', sub_process_id)
      @sub_process = SubProcess.find(sub_process_id)

      initialize_instance_vars
    end
  end

  def show
  end

  def new
    @sub_process = SubProcess.find(params[:sub_process_id])
    initialize_instance_vars
    @task = Task.new
  end

  def edit
    @task  = Task.find(params[:id])
    @sub_process = @task.sub_process
    @item = @task.item

    initialize_instance_vars
    if params[:commit]
      @task.item_id = desc_to_item_id(params[:item_desc], Tasks.name.underscore)
      @task.order = params[:order]
    end
  end

  def create
    @items = items_map(Task.name.underscore)
    @sub_process = SubProcess.find(task_params[:sub_process_id])
    @main_process = @sub_process.main_process
    @period = @main_process.period
    @organization_type = @period.organization_type

    @task = Task.new(task_params)
    @task.item_id = desc_to_item_id(params[:item_desc], Task.name.underscore)
    @task.order = params[:order].to_s.rjust(2, '0')  # => '05'

    if @task.save
      redirect_to_index(t('supervisor.tasks.create.success'))
    else
      render :new
    end
  end

  def update
    if params[:commit]
      @items = items_map(SubProcess.name.underscore)
      @task = Task.find(params[:id])
      @task.assign_attributes(task_params)
      @task.item_id = desc_to_item_id(params[:item_desc], Task.name.underscore)

      @sub_process = @task.sub_process
      @main_process = @sub_process.main_process
      @period = @main_process.period
      @task.order = params[:order].to_s.rjust(2, '0')  # => '05'

      if @task.save
        redirect_to_index(t('supervisor.tasks.update.success'))
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
     msg = t('supervisor.tasks.destroy.success')
   else
     msg = t('supervisor.tasks.destroy.error')
   end
     redirect_to_index(msg)
  end

private
  def initialize_instance_vars
    @unit_type    = @sub_process.unit_type
    @main_process = @sub_process.main_process
    @period = @main_process.period
    @organization_type = @period.organization_type
    @items = items_map(Task.name.underscore)
  end

  def task_params
    params.require(:task).permit(:sub_process_id, :item_id, :order)
  end

  def redirect_to_index(msg)
   redirect_to supervisor_tasks_path(commit: t('supervisor.tasks.index.submit'),
     sub_process_id: @task.sub_process_id,
     main_process_id: @task.sub_process.main_process_id,
     period_id: @period.id, organization_type_id: @period.organization_type_id),
     notice: msg
  end

end
