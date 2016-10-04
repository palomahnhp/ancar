class IndicatorSource < ActiveRecord::Base
  belongs_to :indicator
  belongs_to :source

   def copy(i_id, current_user_login)
    im = IndicatorSource.create(self.attributes.merge(id: nil, indicator_id: i_id))
  end
end

