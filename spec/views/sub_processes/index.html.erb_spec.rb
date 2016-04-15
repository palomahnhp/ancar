require 'rails_helper'

RSpec.describe "sub_processes/index", type: :view do
  before(:each) do
    assign(:sub_processes, [
      SubProcess.create!(),
      SubProcess.create!()
    ])
  end

  it "renders a list of sub_processes" do
    render
  end
end
