require 'rails_helper'

RSpec.describe "subtypeorgs/show", type: :view do
  before(:each) do
    @subtypeorg = assign(:subtypeorg, Subtypeorg.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
