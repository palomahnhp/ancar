require 'rails_helper'
require 'warden' # simula el login ver agendas

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

  describe "administrator?" do
    it "is false when the user is not an admin" do
      expect(subject.is_admin?).to be false
    end

    it "is true when the user is an admin" do
      subject.save
      create(:administrator, user: subject)
      expect(subject.is_admin?).to be true
    end
  end

  describe "valuator?" do
    it "is false when the user is not a valuator"
    it "is true when the user is a valuator"
  end

  describe "is_manager?" do
    it "is false when the user is not a manager" do
      expect(subject.is_manager?).to be false
    end

    it "is true when the user is a manager" do
      subject.save
      create(:manager, user: subject)
      expect(subject.is_manager?).to be true
    end
  end

end