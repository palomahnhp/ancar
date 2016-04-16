require 'rails_helper'

RSpec.describe "type_organizations/index", type: :view do
  before(:each) do
    assign(:type_organizations, [
      TypeOrganization.create!(),
      TypeOrganization.create!()
    ])
  end

  it "renders a list of type_organizations" do
    render
  end
end
