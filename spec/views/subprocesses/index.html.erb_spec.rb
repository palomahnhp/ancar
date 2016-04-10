require 'rails_helper'

RSpec.describe "subprocesses/index", type: :view do
  before(:each) do
    assign(:subprocesses, [
      Subprocess.create!(),
      Subprocess.create!()
    ])
  end

  it "renders a list of subprocesses" do
    render
  end
end
