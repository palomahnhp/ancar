class Valuator < ActiveRecord::Base
  belongs_to :user
  delegate :name, to: :user

  validates :user_id, presence: true, uniqueness: true
end
