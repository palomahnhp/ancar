require 'rails_helper'

RSpec.describe "main_processes/index", type: :view do
  before(:each) do
    assign(:main_processes, [
      MainProcess.create!(),
      MainProcess.create!()
    ])
  end

  it "renders a list of main_processes" do
    render
  end
end
