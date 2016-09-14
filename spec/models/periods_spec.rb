require 'rails_helper'

describe "Period" do

  it "is valid with a organization_type_id, description, started_at, ended_at, opened_at, closed_at"
  it "is invalid without a organization_type_id"

  describe "#description" do
    it "is invalid without a description"
    it "is invalid with a short description"
    it "is invalid with a long description"
  end

  describe "dates" do
    it "is invalid whitout started_at"
    it "is invalid whitout ended_at"
    it "is invalid if ended_at is greater than started_at"

    it "is invalid whitout opened_at"
    it "is invalid whitout closed_at"
    it "is invalid if closed_at is greater than opened_at"
  end

end