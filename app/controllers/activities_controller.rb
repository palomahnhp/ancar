class Admin::ActivitiesController  < Admin::BaseController
  before_filter(:only => :index) { unauthorized! if cannot? :index, :activities }

  def index
    @search = PublicActivity::Activity.search(params[:q])

    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @activities = @search.result
    @search.build_condition
  end
end