require 'rails_helper'

RSpec.describe "type_organizations/show", type: :view do
  before(:each) do
    @type_organization = assign(:type_organization, TypeOrganization.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
