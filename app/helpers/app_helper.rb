module AppHelper
  def description(id, item_id)
    if id == 0
     "#{Item.find(item_id).description}"
    else
     "#{id}. #{Item.find(item_id).description}"
    end
  end
  def sources(id)
    Indicator.find(id).sources
  end
end