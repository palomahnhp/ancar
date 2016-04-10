require 'rails_helper'

RSpec.describe "subprocesses/edit", type: :view do
  before(:each) do
    @subprocess = assign(:subprocess, Subprocess.create!())
  end

  it "renders the edit subprocess form" do
    render

    assert_select "form[action=?][method=?]", subprocess_path(@subprocess), "post" do
    end
  end
end
