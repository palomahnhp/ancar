require 'active_support/concern'
module Trackable
  extend ActiveSupport::Concern

  included do
    include PublicActivity::Model
    tracked owner: ->(controller, _model) { controller && controller.current_user },
           :params => {
              :params => proc {|controller, model_instance| controller && controller.params},
    }
  end
end
