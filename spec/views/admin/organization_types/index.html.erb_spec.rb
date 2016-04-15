require 'rails_helper'

RSpec.describe "admin/organization_types/index", type: :view do
  before(:each) do
    assign(:admin_organization_types, [
      Admin::OrganizationType.create!(),
      Admin::OrganizationType.create!()
    ])
  end

  it "renders a list of admin/organization_types" do
    render
  end
end
