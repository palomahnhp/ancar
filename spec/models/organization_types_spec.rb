require 'rails_helper'

describe 'OrganizationType', type: :model do

  let(:organization_type) { build(:organization_type) }

  it 'is valid with a acronym and a description and dates' do
    expect(organization_type).to be_valid
  end

  it 'is invalid without a acronym' do
    organization_type.acronym = nil
    expect(organization_type).not_to be_valid
  end

  it 'is invalid without a description' do
    organization_type.description = nil
    expect(organization_type).not_to be_valid
  end

  it 'is invalid with a short description'
  it 'is invalid with a long description'

  it 'is invalid whitout started_at'
  it 'is invalid whitout ended_at'
  it 'is invalid if ended_at is greater than started_at'

  it 'is invalid whitout opened_at'
  it 'is invalid whitout closed_at'
  it 'is invalid if closed_at is greater than opened_at'

end