class Doc  < ActiveRecord::Base

  validates_presence_of :name, :url
  validates_inclusion_of :format, in: %w[PDF JPG PNG]

end