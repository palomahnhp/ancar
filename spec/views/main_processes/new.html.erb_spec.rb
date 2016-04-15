require 'rails_helper'

RSpec.describe "main_processes/new", type: :view do
  before(:each) do
    assign(:main_process, MainProcess.new())
  end

  it "renders new main_process form" do
    render

    assert_select "form[action=?][method=?]", main_processes_path, "post" do
    end
  end
end
