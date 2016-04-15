require 'rails_helper'

RSpec.describe "admin/organization_types/show", type: :view do
  before(:each) do
    @admin_organization_type = assign(:admin_organization_type, Admin::OrganizationType.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
