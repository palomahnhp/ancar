FactoryGirl.define do
  factory :admin_source, class: 'Admin::Source' do
    
  end

  factory :user do
    login  "USU" + Faker::Number.number(3)
    sequence(:name) { |n| "Nombre#{n}" }
    sequence(:surname)  { |n| "Apellido_1_#{n}" }
    sequence(:second_surname) { |n| "Apellido_2_#{n}" }
    pernr Faker::Number.number(8)
    uweb_id  Faker::Number.number(8)

    trait :inactive do
      intactivated_at = Time.now - 1.month
    end

    trait :interlocutor_sgt do
      after :create do |user|
        organization = Organization.where(organization_type: OrganizationType.find_by_description('Secretarías Generales Técnicas')).take
        user.add_role(:interlocutor, organization)
      end
    end

    trait :interlocutor_distrito do
      after :create do |user|
        organization = Organization.where(organization_type: OrganizationType.find_by_description('Distritos')).take
        user.add_role(:interlocutor, organization)
      end
    end

    trait :with_one_organization do
      after :create do |user|
        organization = Organization.where(organization_type_id: 1).first
        user.add_role(:interlocutor, organization)
      end
    end

    trait :with_two_organizations do
      after :create do |user|
        organization = Organization.where(organization_type_id: 1).first
        user.add_role(:interlocutor, organization)
        organization = Organization.where(organization_type_id: 1).last
        user.add_role(:interlocutor, organization)
      end
    end

    trait :SGT do
      after :create do |user|
        organization = Organization.where(organization_type: OrganizationType.find_by_description('Secretarías Generales Técnicas')).first
        user.add_role(:interlocutor, organization)
      end
    end

    trait :distrito do
      after :create do |user|
        organization = Organization.where(organization_type: OrganizationType.find_by_description('Distritos')).first
        user.add_role(:interlocutor, organization)
      end
    end

    factory :admin do
      after :create do |user|
        user.add_role(:admin)
      end
    end

    factory :supervisor_global do
      after(:create) do |user|
        user.add_role(:supervisor)
      end
    end

    factory :supervisor_with_all_organization_types do
      after(:create) do |user|
        user.add_role(:supervisor, OrganizationType)
      end
    end

    factory :validator do
      after(:create) do |user|
        user.add_role(:validator, Organization.first)
      end
    end
  end

  factory :period do
    association :organization_type, factory: :organization_type
    description 'Periodo de análisis de datos'
    started_at  (Time.now - 1.year).beginning_of_year
    ended_at    (Time.now - 1.year).end_of_year
    opened_at   (Time.now - 1.year).end_of_year + 1.day
    closed_at   (Time.now - 1.year).end_of_year + 1.month
    trait :open do
      closed_at  Time.now + 1.day
      description 'Periodo abierto'
    end

    trait :close do
      closed_at  Time.now - 1.day
      description 'Periodo cerrado'
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
    association :indicator, factory: :indicator
    association :metric, factory: :metric
  end

  factory :indicator_source do
    association :indicator_metric, factory: :indicator
    association :source, factory: :source
  end

  factory :metric do
    association :item, :factory => [:item, :metric]
  end

  factory :source do
    association :item, :factory => [:item, :source]
  end

  factory :entry_indicator do
    association :indicator_metric, factory: :indicator_metric
    amount 13.5
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

    trait :source do
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
    trait :sgts do
      after :create do |organization_type|
        organization_type.description  = 'Secretarías Generales Técnicas'
        organization_type.acronym  = 'SGT'
      end
    end
    trait :distritos do
      after :create do |organization_type|
        organization_type.description  = 'Distritos'
        organization_type.acronym  = 'JD'
      end
    end
  end


  factory :organization do
    association :organization_type, factory: :organization_type, strategy: :build
    sequence(:description) { |n| "Organización #{n}" }
    sequence(:short_description) { |n| "Org.#{n}" }
    sequence(:sap_id, 10200000)  { |n| "#{n}" }
  end

  factory :doc do

    trait :general_access do
      name 'Documento acceso general'
      description 'Ejemplo de documento de analísis de cargas de trabajo de las unidades municipales'
      url 'docs/Manual de uso.pdf'
      format 'PDF'
    end

    trait :instructions_jd do
      name 'Instrucciones Distritos'
      description 'Ejemplo de documento de analísis de cargas de trabajo de las unidades municipales'
      url 'instructions?jd'
#      organization_type_id OrganizationType.find_by_description('Distritos')
      format 'HTML'
      association :organization_type, :factory=> [:organization_type, :distritos]
    end

    trait :instructions_sgt do
      name 'Instrucciones SGTs'
      description 'Ejemplo de documento de analísis de cargas de trabajo de las unidades municipales'
      url 'instructions?sgt'
      format 'HTML'
      association :organization_type, :factory=> [:organization_type, :sgts]
    end
  end
end
