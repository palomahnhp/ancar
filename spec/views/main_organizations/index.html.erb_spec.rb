require 'rails_helper'

RSpec.describe "main_organizations/index", type: :view do
  before(:each) do
    assign(:main_organizations, [
      MainOrganization.create!(),
      MainOrganization.create!()
    ])
  end

  it "renders a list of main_organizations" do
    render
  end
end
