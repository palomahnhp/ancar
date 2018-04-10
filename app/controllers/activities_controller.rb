class Admin::ActivitiesController  < Admin::BaseController
  before_filter(:only => :index) { unauthorized! if cannot? :index, :activities }

  def index
    @activities = PublicActivity::Activity.all.order(created_at: :desc)
  end
end