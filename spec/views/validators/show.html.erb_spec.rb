require 'rails_helper'

RSpec.describe "validators/show", type: :view do
  before(:each) do
    @validator = assign(:validator, Validator.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
