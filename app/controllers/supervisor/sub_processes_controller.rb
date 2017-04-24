class Supervisor::SubProcessesController < Supervisor::BaseController

  def index
    @main_process = MainProcess.find(params[:main_process_id])
    @sub_processes = @main_process.sub_processes.order(:unit_type_id, :order)
    @unit_type_before = ''
  end

  def show
  end

  def new
    @main_process = MainProcess.find(params[:main_process_id])
    @sub_process = @main_process.sub_processes.new
  end

  def edit
    @sub_process  = SubProcess.find(params[:id])
  end

  def create
    @sub_process = SubProcess.new(sub_process_params)
    @sub_process.item = Item.find_or_create_by(item_type: 'sub_process', description: params[:item_description]) unless params[:item_description].empty?
    @main_process = @sub_process.main_process
    @sub_process.updated_by = current_user.login
    it_task = Item.find_or_create_by(item_type: 'task', description: 'Tarea')
    if @sub_process.save
      @sub_process.tasks.find_or_create_by(item_id: it_task.id)
      redirect_to_index(t('supervisor.sub_processes.create.success'))
    else
      render :new
    end
  end

  def update
    @sub_process = SubProcess.find(params[:id])
    @sub_process.assign_attributes(sub_process_params)
    @sub_process.item = Item.find_or_create_by(item_type: 'sub_process', description: params[:item_description]) unless params[:item_description].empty?
    @sub_process.updated_by = current_user.login
    if @sub_process.save
      redirect_to_index(t('supervisor.sub_processes.update.success'))
    else
      render :edit
    end
  end

  def destroy
   @sub_process = SubProcess.find(params[:id])
   @main_process = @sub_process.main_process
   @period = @main_process.period

   if @sub_process.destroy
     msg = t('supervisor.sub_processes.destroy.success')
   else
     msg = t('supervisor.sub_processes.destroy.error')
   end
    redirect_to_index(msg)
  end

  private
    def sub_process_params
      params.require(:sub_process).permit(:main_process_id, :item_id, :order, :unit_type_id, :updated_by)
    end

    def redirect_to_index(msg)
     redirect_to supervisor_sub_processes_path(commit: t('supervisor.sub_processes.index.submit'),
       main_process_id: @sub_process.main_process_id), notice: msg
   end


end
