class Item < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user },
          :params => {
              :id => :id,
              :description => proc {|controller, model_instance| model_instance.description},
          }

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :main_processes
  has_many :sub_processes
  has_many :tasks
  has_many :indicators
  has_many :sources
  has_many :summary_types
  has_many :total_indicator_types

  scope :active, -> {where(active: [nil, true])}

end
