require 'rails_helper'

RSpec.describe "type_organizations/edit", type: :view do
  before(:each) do
    @type_organization = assign(:type_organization, TypeOrganization.create!())
  end

  it "renders the edit type_organization form" do
    render

    assert_select "form[action=?][method=?]", type_organization_path(@type_organization), "post" do
    end
  end
end
