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

  it "User should authenticate for a valid email and password" do
    user = User.create!(@attr)
    User.authenticate("user@example.com", "password").should == user 
  end

  it "User authentication should fail if email and password dont match" do
    user = User.create!(@attr)
    User.authenticate("user@example.com", "invalid").should be_nil
  end

  describe "administrative users" do

      it "should response to admin?" do
          user = User.create!(@attr)
          user.should respond_to(:admin)
      end

      it "should not be an admin by default" do
          user = User.create!(@attr)
          user.should_not be_admin 
      end

      it "should be able to become admin" do
          user = User.create!(@attr)
          user.toggle!(:admin)
          user.should be_admin 
      end

  end

  describe "micrposts" do

      before(:each) do
          @user = User.create!(@attr)
          @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
          @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
      end

      it "should response to micrposts" do
          @user.should respond_to(:microposts)
      end

     it "shoulds return posts in newest to oldest sequence" do
         @user.microposts.should == [@mp2, @mp1]
     end

     it "should destroy associated microposts" do
         @user.destroy
         [@mp1, @mp2].each do |micropost|
             Micropost.find_by_id(micropost.id).should be_nil
         end
     end

  end

  describe "status feed" do

      before(:each) do
          @user = User.create!(@attr)
          @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
          @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
      end

      it "should have a feed" do
          @user.should respond_to(:feed)
      end

      it "should include the user's microposts" do
          @user.feed.include?(@mp1).should be_true
          @user.feed.include?(@mp2).should be_true
      end

      it "should not include a different user's microposts" do
           mp3 = Factory(:micropost,
                           :user => Factory(:user, :email => Factory.next(:email)))
           @user.feed.include?(mp3).should be_false
      end
  end


    describe "relationships" do

        before(:each) do
            @user = User.create!(@attr)
            @followed = Factory(:user)
        end

        it "should have a relationships method" do
            @user.should respond_to(:relationships)
        end

        it "should have a following method" do
            @user.should respond_to(:following)
        end

        it "should have a follow! method" do
            @user.should respond_to(:follow!)
        end

        it "should have a following? method" do
            @user.should respond_to(:following?)
        end

        it "should allow a user to follow the current user" do
            @user.follow!(@followed)
            @user.should be_following(@followed)
        end

        it "should include the followed user in the array" do
            @user.follow!(@followed)
            @user.following.should include(@followed)
        end

        it "should be possible to unfollow a user" do
            @user.follow!(@followed)
            @user.should be_following(@followed)
            @user.unfollow!(@followed)
            @user.should_not be_following(@followed)
        end

        it "should have a followers method" do
            @user.should respond_to(:followers)
        end

        it "should have a reverse_relationships method" do
            @user.should respond_to(:reverse_relationships)
        end

        it "should include the follower in the followers array" do
            @user.follow!(@followed)
            @followed.followers.should include(@user)
        end
    end

end
