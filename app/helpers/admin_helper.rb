module AdminHelper

  def side_menu
    render "/#{namespace}/menu"
  end

  def organization_type_select_options
    @organization_types.collect { |v| [ v.description, v.id ] }
  end

  def period_select_options
    @periods.collect { |v| [ v.description, v.id ] }
  end

  def main_process_items
    mp = MainProcess.all.uniq.pluck(:id)
    items_not_used = Item.where(item_type: "main_process").where.not(id: mp)
    items_not_used.collect  { |v| [ v.id, v.id ] }
  end

  private
    def namespace
      controller.class.parent.name.downcase
    end
end
