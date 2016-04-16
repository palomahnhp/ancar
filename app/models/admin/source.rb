class Admin::Source < ActiveRecord::Base
  has_many :indicator_sources
end
