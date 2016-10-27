FactoryGirl.define do
  factory :indicator_type do
    
  end

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
  end

  factory :administrator do
    user
  end

  factory :manager do
    user
  end
end