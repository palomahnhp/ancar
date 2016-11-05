module ManagerActions
  extend ActiveSupport::Concern

    def unit_types
      @unit_types = UnitType.all.map { |type| [type.description, type.id] }
    end

    def item_new(description, class_name)
      Item.create(item_type: class_name, description: description).id
    end

    def metric_new(description)
      item = item_new(description, class_name)
      Metric.create(item_id: item).id
    end

    def source_new(description)
      item = item_new(description, Source.name.underscore)
      Source.create(item_id: item).id
    end

    def desc_to_item_id(description, class_name)
      @items.to_h[description].nil? ? item_new(description, class_name) : @items.to_h[description]
    end

    def desc_to_unit_type_id(description)
      @unit_types.to_h[description]
    end

    def select_option_descriptions(class_name)
      Item.where(item_type: class_name).order(:description).map{|item| [item.description, item.id]}
    end

    def items_map(class_name)
      Item.where(item_type: class_name).order(:description).map{|item| [item.description, item.id]}
    end
end
