namespace :db do
  desc "Resets the database and loads it from db/dev_seeds.rb"
  task dev_seed: :environment do
    load(Rails.root.join("db", "dev_seeds.rb"))
  end
  desc "Resets the database and loads it from db/import_seed.rb"
  task import_seed: :environment do
    load(Rails.root.join("db", "import_seeds.rb"))
  end
  task items_indicators_out: :environment do
    Item.create!(item_type: "indicator_type", description: "Proceso", updated_by: "import")
    Item.create!(item_type: "indicator_type", description: "Subproceso", updated_by: "import")
    Item.create!(item_type: "indicator_type", description: "Stock", updated_by: "import")
    Item.create!(item_type: "indicator_type", description: "Sub-subproceso", updated_by: "import")
    Item.create!(item_type: "indicator_type", description: "Control", updated_by: "import")
  end
end
