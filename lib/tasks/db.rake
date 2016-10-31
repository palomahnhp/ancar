namespace :db do
  desc "Resets the database and loads it from db/dev_seeds.rb"
  task dev_seed: :environment do
    load(Rails.root.join("db", "dev_seeds.rb"))
  end
  desc "Resets the database and loads it from db/import_seed.rb"
  task import_seed: :environment do
    load(Rails.root.join("db", "import_seeds.rb"))
  end
end
