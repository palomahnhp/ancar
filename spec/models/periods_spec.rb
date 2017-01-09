require 'rails_helper'

describe "Period" do
  let(:period) { build(:period) }

  it "is valid" do
    expect(period).to be_valid
  end

  it "is invalid without a organization_type_id" do
    period.organization_type_id = nil
    expect(period).to be_invalid
  end

  describe "description" do
    it "is invalid without a description" do
      period.description = nil
      expect(period).to be_invalid
    end

    it "is invalid with a short description" do
      period.description = "a"*3
      expect(period).to be_invalid
    end

    it "is invalid with a long description" do
      period.description = "a"*110
      expect(period).to be_invalid
    end
  end

  describe "dates" do
    it "is invalid whitout started_at" do
      period.started_at = nil
      expect(period).to be_invalid
    end

    it "is invalid whitout ended_at" do
      period.ended_at = nil
      expect(period).to be_invalid
    end

    it "is invalid if started_at is greater than ended_at" do
      period.started_at = period.ended_at + 1.day
      expect(period).to be_invalid
    end

    it "is invalid whitout opened_at" do
      period.opened_at = nil
      expect(period).to be_invalid
    end

    it "is invalid whitout closed_at" do
      period.closed_at = nil
      expect(period).to be_invalid
    end

    it "is invalid if opened_at is greater than closed_at" do
      period.opened_at = period.closed_at + 1.day
      expect(period).to be_invalid
    end

  end

  describe  "status " do
    it "is open entry" do
      period.started_at = DateTime.now - 100.days
      period.ended_at = period.started_at + 80.days
      period.opened_at = DateTime.now - 10.days
      period.closed_at = period.opened_at + 10.days
      expect(period).to be_valid
    end

    it "is close entry" do
      period.started_at = DateTime.now - 100.days
      period.ended_at = period.started_at + 80.days
      period.opened_at = DateTime.now - 10.days
      period.closed_at = DateTime.now - 1.day
      expect(period).to be_valid
    end

  end

end