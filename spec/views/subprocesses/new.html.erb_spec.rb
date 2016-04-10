require 'rails_helper'

RSpec.describe "subprocesses/new", type: :view do
  before(:each) do
    assign(:subprocess, Subprocess.new())
  end

  it "renders new subprocess form" do
    render

    assert_select "form[action=?][method=?]", subprocesses_path, "post" do
    end
  end
end
