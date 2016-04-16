require 'rails_helper'

RSpec.describe "main_processes/edit", type: :view do
  before(:each) do
    @main_process = assign(:main_process, MainProcess.create!())
  end

  it "renders the edit main_process form" do
    render

    assert_select "form[action=?][method=?]", main_process_path(@main_process), "post" do
    end
  end
end
