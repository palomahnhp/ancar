class Organization < ActiveRecord::Base
  resourcify
  belongs_to :organization_type
  has_many :units
  has_many :users

  def self.select_options
    self.all.collect { |v| [ v.description, v.id ] }
  end

end
