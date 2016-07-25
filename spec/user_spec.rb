require 'spec_helper.rb'

describe 'User' do
  describe "#username" do
    it "will return the username for a user" do
      test_user = User.new(:username => "djrock", :password => "12345")
      test_user.save
      expect(test_user.username).to eq("djrock")
    end
  end
end
