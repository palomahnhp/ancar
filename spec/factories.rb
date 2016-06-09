FactoryGirl.define do
  factory :user do
    
  end
  factory :output_indicator do
    
  end
  sequence(:document_number) { |n| "#{n.to_s.rjust(8, '0')}X" }

  factory :period do
    sequence(:description) { |n| "Periodo#{n}" }

    started_at        { Time.now }
  end
end