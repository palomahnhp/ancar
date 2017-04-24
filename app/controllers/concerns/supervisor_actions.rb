module SupervisorActions
  extend ActiveSupport::Concern

    def unit_types
      @unit_types = UnitType.all.map { |type| [type.description, type.id] }
    end

    def item_new(description, class_name)
      Item.create(item_type: class_name, description: description).id
    end

    def metric_new(description, class_name)
      item = item_new(description, class_name)
      Metric.create(item_id: item).id
    end

    def source_new(description, class_name)
      item = item_new(description, Source.name.underscore)
      Source.create(item_id: item).id
    end

    def desc_to_item_id(description, class_name)
      if description.nil? then return nil end
      @items.to_h[description].nil? ? item_new(description, class_name) : @items.to_h[description]
    end

    def desc_to_metric_id(description, class_name)
      if description.nil? then return nil end
      Metric.find_by_item_id(@metrics.to_h[description]).nil? ? metric_new(description, class_name) : Metric.find_by_item_id(@metrics.to_h[description]).id
    end

    def desc_to_source_id(description, class_name)
      if description.nil? then return nil end
      Source.find_by_item_id(@sources.to_h[description]).nil? ? source_new(description, class_name) : Source.find_by_item_id(@sources.to_h[description]).id
    end

    def desc_to_unit_type_id(description)
      @unit_types.where(description: description).take.id
    end

    def select_option_descriptions(class_name)
      Item.where(item_type: class_name).order(:description).map{|item| [item.description, item.id]}
    end

    def items_map(class_name)
      Item.where(item_type: class_name).order(:description).map{|item| [item.description, item.id]}
    end
end
