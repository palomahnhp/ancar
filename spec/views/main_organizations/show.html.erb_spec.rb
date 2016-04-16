require 'rails_helper'

RSpec.describe "main_organizations/show", type: :view do
  before(:each) do
    @main_organization = assign(:main_organization, MainOrganization.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
