require 'rails_helper'

RSpec.describe "mainprocesses/show", type: :view do
  before(:each) do
    @mainprocess = assign(:mainprocess, Mainprocess.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
