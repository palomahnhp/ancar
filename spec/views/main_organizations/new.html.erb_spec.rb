require 'rails_helper'

RSpec.describe "main_organizations/new", type: :view do
  before(:each) do
    assign(:main_organization, MainOrganization.new())
  end

  it "renders new main_organization form" do
    render

    assert_select "form[action=?][method=?]", main_organizations_path, "post" do
    end
  end
end
