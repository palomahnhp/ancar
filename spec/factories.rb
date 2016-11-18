FactoryGirl.define do

  factory :period do
    association :organization_type, factory: :organization_type
    sequence(:description) {|n|  "Periodo año #{n} actual"}
    started_at  '20150101'
    ended_at    '20151231'
    opened_at   '20160101'
    closed_at   '20160331'

    trait :open do
      closed_at  Time.now + 1.day
    end

    trait :close do
      closed_at  Time.now - 1.day
    end
  end

  factory :main_process do
    association :period, factory: :period
    association :item, :factory => [:item, :main_process]
    sequence(:order) {|n|  "#{n}"}
  end

  factory :sub_process do
    association :main_process, factory: :main_process
    association :item, :factory => [:item, :sub_process]
    association :unit_type, factory: :unit_type
    sequence(:order) {|n|  "#{n}"}
  end

  factory :task do
    association :sub_process, factory: :sub_process
    association :item, :factory => [:item, :task]
    sequence(:order) {|n|  "#{n}"}
  end

  factory :indicator do
    association :item, :factory => [:item, :indicator]
    association :task, factory: :task

    sequence(:order) {|n|  "#{n}"}
  end

  factory :indicator_metric do
    association :metric, factory: :metric
  end

  factory :indicator_source do
    association :source, factory: :source
  end

  factory :metric do
    association :item, :factory => [:item, :metric]
  end

  factory :source do
    association :item, :factory => [:item, :source]
  end

  factory :item do
    description 'item sin trait'

    trait :main_process do
      item_type 'main_process'
      sequence(:description) {|n|  "MainProcess #{n}"}
    end

    trait :sub_process do
      item_type 'sub_process'
      sequence(:description) {|n|  "SubProcess #{n}"}
    end

    trait :task do
      item_type 'task'
      sequence(:description) {|n|  "Task #{n}"}
    end

    trait :indicator do
      item_type 'indicator'
      sequence(:description) {|n|  "Indicator #{n}"}
    end

    trait :metric do
      item_type 'metric'
      sequence(:description) {|n|  "Metric #{n}"}
    end
    trait :metric do
      item_type 'source'
      sequence(:description) {|n|  "Source #{n}"}
    end
  end

  factory :unit_type do
    association :organization_type, factory: :organization_type
    sequence(:description) {|n|  "Tipo de unidad #{n}"}
    sequence(:order) {|n|  "#{n}"}
  end

  factory :organization_type do
    sequence(:description) { |n| "Tipo de organización#{n}" }
    sequence(:acronym) { |n| "TipOrg#{n}" }
  end


  factory :organization do
    association :organization_type, factory: :organization_type, strategy: :build
    sequence(:description) { |n| "Organización #{n}" }
    sequence(:short_description) { |n| "Org.#{n}" }
    sequence(:sap_id, 10200000)  { |n| "#{n}" }
  end

  factory :user do
    sequence(:login) { |n| "usu00#{n}" }
    sequence(:name) { |n| "Nombre#{n}" }
    sequence(:surname)  { |n| "Apellido_1_#{n}" }
    sequence(:second_surname) { |n| "Apellido_2_#{n}" }
    sequence(:pernr) { |n| }

    trait :admin do
      role 'admin'
    end

    trait :manager do
      role 'manager'
    end
  end
end