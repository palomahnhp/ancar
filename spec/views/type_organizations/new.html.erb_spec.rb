require 'rails_helper'

RSpec.describe "type_organizations/new", type: :view do
  before(:each) do
    assign(:type_organization, TypeOrganization.new())
  end

  it "renders new type_organization form" do
    render

    assert_select "form[action=?][method=?]", type_organizations_path, "post" do
    end
  end
end
