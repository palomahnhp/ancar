require 'rails_helper'

RSpec.describe "main_organizations/edit", type: :view do
  before(:each) do
    @main_organization = assign(:main_organization, MainOrganization.create!())
  end

  it "renders the edit main_organization form" do
    render

    assert_select "form[action=?][method=?]", main_organization_path(@main_organization), "post" do
    end
  end
end
