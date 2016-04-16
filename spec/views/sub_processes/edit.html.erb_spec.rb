require 'rails_helper'

RSpec.describe "sub_processes/edit", type: :view do
  before(:each) do
    @sub_process = assign(:sub_process, SubProcess.create!())
  end

  it "renders the edit sub_process form" do
    render

    assert_select "form[action=?][method=?]", sub_process_path(@sub_process), "post" do
    end
  end
end
