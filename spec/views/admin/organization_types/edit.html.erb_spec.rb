require 'rails_helper'

RSpec.describe "admin/organization_types/edit", type: :view do
  before(:each) do
    @admin_organization_type = assign(:admin_organization_type, Admin::OrganizationType.create!())
  end

  it "renders the edit admin_organization_type form" do
    render

    assert_select "form[action=?][method=?]", admin_organization_type_path(@admin_organization_type), "post" do
    end
  end
end
