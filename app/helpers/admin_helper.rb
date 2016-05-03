module AdminHelper

  def side_menu
    render "/#{namespace}/menu"
  end

  def organization_type_select_options
    @organization_types.collect { |v| [ v.name, v.id ] }
  end

  def period_select_options
    @periods.collect { |v| [ v.name, v.id ] }
  end

  def main_process_items
     @items.collect  { |v| [ v.description, v.id ] }
  end

  private

    def namespace
      controller.class.parent.name.downcase
    end

end
