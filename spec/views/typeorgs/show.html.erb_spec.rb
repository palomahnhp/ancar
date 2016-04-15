require 'rails_helper'

RSpec.describe "typeorgs/show", type: :view do
  before(:each) do
    @typeorg = assign(:typeorg, Typeorg.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
