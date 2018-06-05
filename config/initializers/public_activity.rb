module PublicActivity
  class Activity
    belongs_to :owner, class_name: 'User'
    belongs_to :trackable, class_name: 'Period'

    def self.ransackable_attributes(auth_object = nil)
      %w(trackable_type trackable_id owner key parameters created_at ) + _ransackers.keys
    end

  end
end
  