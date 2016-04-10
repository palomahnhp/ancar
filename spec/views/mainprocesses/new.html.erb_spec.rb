require 'rails_helper'

RSpec.describe "mainprocesses/new", type: :view do
  before(:each) do
    assign(:mainprocess, Mainprocess.new())
  end

  it "renders new mainprocess form" do
    render

    assert_select "form[action=?][method=?]", mainprocesses_path, "post" do
    end
  end
end
