FactoryGirl.define do

    factory :user do
      sequence(:ayre) { |n| "usu00#{n}" }
      sequence(:name) { |n| "Nombre#{n}" }
      sequence(:first_surname)  { |n| "Apellido_1_#{n}" }
      sequence(:second_surname) { |n| "Apellido_2_#{n}" }
    end

end