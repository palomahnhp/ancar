require 'active_support/concern'
module ItemTrackable
  extend ActiveSupport::Concern


  included do
    include PublicActivity::Model
    tracked owner: ->(controller, model) { controller && controller.current_user },
           :params => {
              :id => :id,
              :description => proc {|controller, model_instance| model_instance.item.description},
    }
  end
end
