require 'rails_helper'

RSpec.describe "mainprocesses/edit", type: :view do
  before(:each) do
    @mainprocess = assign(:mainprocess, Mainprocess.create!())
  end

  it "renders the edit mainprocess form" do
    render

    assert_select "form[action=?][method=?]", mainprocess_path(@mainprocess), "post" do
    end
  end
end
