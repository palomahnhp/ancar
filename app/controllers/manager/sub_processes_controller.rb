class Manager::SubProcessesController < Manager::BaseController

  before_action :unit_types, only: [:edit, :new, :create, :update]

  def index
    if params[:commit] == t("manager.sub_processes.index.submit")
      if params[:sub_processes].nil?
        main_process_id = params[:main_process_id]
      else
      main_process_id = params[:sub_processes][:main_process_id]
      end
      @sub_processes = SubProcess.where("main_process_id = ?", main_process_id).order(:unit_type_id, :order)
      @main_process = MainProcess.find(main_process_id)
      @period = Period.find(@main_process.period_id)
      @organization_type = OrganizationType.find(@period.organization_type_id)
      @unit_type_before = ""
    end
  end

  def show
    redirect_to in_works_path, alert: "Opción no disponible. Lo estará proximamente"
    @sub_process = SubProcess.find_by("id = ?", params[:main_process])
  end

  def edit
    @items = Item.where(item_type: SubProcess.class.name.underscore).order(:description).map{|item| [item.description, item.id]}
    @sub_process  = SubProcess.find(params[:id])
    @unit_type    = @sub_process.unit_type #UnitType.find(@sub_process.unit_type_id)
    @main_process = @sub_process.main_process #MainProcess.find(@sub_process.main_process_id)
    @period       = @sub_process.main_process.period
    @organization_type = OrganizationType.find(@unit_type.organization_type_id)
    @unit_types   = UnitType.where(organization_type_id: @organization_type.id).order(:order)
    if params[:commit]
      @sub_process.item_id =  desc_to_item_id(params[:item_desc], Subprocess.name.underscore)
      @sub_process.order = params[:order]
      if @sub_process.save
        redirect_to manager_sub_processes_path(commit: t("manager.sub_processes.index.submit"),
           main_process_id: @sub_process.main_process_id,
           period_id: @period.id, organization_type_id: @period.organization_type_id)
      else
        render :edit
      end
    end
  end

  def destroy
     if @sub_process.destroy_all
       msg = t("manager.sub_processes.index.destroy.success")
     else
       msg = t("manager.sub_processes.index.destroy.error")
     end
     redirect_to manager_sub_processes_path, notice: msg
  end

end
