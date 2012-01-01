require 'spec_helper'

describe User do
    before(:each) do 
        @attr = { 
          :name => "Example User", 
          :email => "user@example.com",
          :password => "password",
          :password_confirmation => "password"
          }
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

    it "should respond to encrypted_password" do
       user = User.create(@attr)
       user.should respond_to(:encrypted_password)
    end

end

describe "Password Validation" do
  before(:each) do 
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com",
      :password => "password",
      :password_confirmation => "password"
    }
  end

  it "should require a password!" do
    user = User.new(@attr.merge :password => "", :password_confirmation => "")
    user.should_not be_valid
  end

  it "should require confirmation to matc password!" do
    user = User.new(@attr.merge :password_confirmation => "123456")
    user.should_not be_valid
  end

  it "should reject short passwords" do
    user = User.new(@attr.merge(:password => "a" * 5, :password_confirmation => "a" * 5))
    user.should_not be_valid
  end

  it "should reject passwords that are to long" do
    user = User.new(@attr.merge(:password => "a" * 55, :password_confirmation => "a" * 55))
    user.should_not be_valid
  end

  it "should have an encrypted password" do
    user = User.create!(@attr)
    user.encrypted_password.should_not be_blank
  end

  it "has a secure password which matches ours" do
    user = User.create!(@attr)
    user.has_password?("password").should be_true
  end
  
  it "Should fail a has_password call if the password does not match" do
    user = User.create!(@attr)
    user.has_password?("invalid").should be_false
  end


end
