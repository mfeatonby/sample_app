require 'spec_helper'

describe User do
    before(:each) do 
        @attr = { :name => "Example name", :email => "user@example.com" }
    end

    it "should create a new instance given valid attributes" do
      User.create!(@attr)
    end

    it "should require a name" do
      user = User.new(@attr.merge(:name => ""))
      user.should_not be_valid
    end

    it "should require an email address" do
      user = User.new(@attr.merge(:email => ""))
      user.should_not be_valid
    end

    it "name should be shorter than 50 characters"do
      user = User.new(@attr.merge(:name => "1234567890123456789012345678901234567890123456789012345678901234567890"))
      user.should_not be_valid
    end

    it "should be a valid email address" do
      user = User.new(@attr.merge(:email => "testing"))
      user.should_not be_valid
    end

    it "should reject a duplicate email address" do
      user = User.create(@attr)
      duplicate_user = User.create(@attr)
      duplicate_user.should_not be_valid
    end

    it "should reject a duplicate email address regardless of case" do
      user = User.create(@attr)
      duplicate_user = User.create(@attr.merge(:email => "USER@EXAMPLE.COM"))
      duplicate_user.should_not be_valid
    end

end
