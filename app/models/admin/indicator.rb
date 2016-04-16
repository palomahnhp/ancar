class Admin::Indicator < ActiveRecord::Base
  belongs_to :task
  has_many :indicator_sources
end
