require 'rails_helper'

RSpec.describe "admin/units/show", type: :view do
  before(:each) do
    @admin_unit = assign(:admin_unit, Admin::Unit.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
