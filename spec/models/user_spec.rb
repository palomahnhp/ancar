require 'rails_helper'

describe User do

  subject { build(:user) }

  it "is valid" do
    user1 = create(:user, login: subject.login)
    expect(user1).to be_valid
  end

  it "is unique" do
    user1 = create(:user, login: subject.login)
    user2 = build(:user, login: subject.login)
    expect(user2).to be_invalid
  end

  describe "validator?" do
    it "is false when the user is not a valuator" do
      expect(subject.validator?).to be false
    end

    it "is true when the user is a validator" do
      subject.role = 1
      expect(subject.validator?).to be true
    end
  end

  describe "is_manager?" do
    it "is false when the user is not a manager" do
      expect(subject.manager?).to be false
    end

    it "is true when the user is a manager" do
      subject.role = 2
      expect(subject.manager?).to be true
    end
  end

  describe "administrator?" do
    it "is false when the user is not an admin" do
      expect(subject.admin?).to be false
    end

    it "is true when the user is an admin" do
      subject.role = 3
      expect(subject.admin?).to be true
    end
  end

end