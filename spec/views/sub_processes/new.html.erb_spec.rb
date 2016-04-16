require 'rails_helper'

RSpec.describe "sub_processes/new", type: :view do
  before(:each) do
    assign(:sub_process, SubProcess.new())
  end

  it "renders new sub_process form" do
    render

    assert_select "form[action=?][method=?]", sub_processes_path, "post" do
    end
  end
end
