require 'rails_helper'

RSpec.describe "admin/organization_types/new", type: :view do
  before(:each) do
    assign(:admin_organization_type, Admin::OrganizationType.new())
  end

  it "renders new admin_organization_type form" do
    render

    assert_select "form[action=?][method=?]", admin_organization_types_path, "post" do
    end
  end
end
