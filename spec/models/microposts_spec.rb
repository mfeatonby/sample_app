require 'spec_helper'

describe Micropost do

    before (:each) do 
        @user = User.create!(:name => "test", :email => "emailabc@example.com", :password => "password", :password_confirmation => "password")
        @attr = {:content => "Hello"}
    end

    it "should create successfully" do
        post = @user.microposts.create(@attr)
        post.content.should == @attr[:content]
    end

    describe "user associations" do

        before (:each) do 
            @user = User.create!(:name => "test", :email => "emaildef@example.com", :password => "password", :password_confirmation => "password")
            @post = @user.microposts.create({:content => "Hello"})
        end

        it "should respond to user" do
            @post.should respond_to(:user)
        end

        it "should be associated with the correct user" do
            @post.user.should == @user
            @post.user_id.should == @user.id
        end

    end

    describe "microspost validation" do

        before (:each) do 
            @user = User.create!(:name => "test", :email => "emaildef@example.com", :password => "password", :password_confirmation => "password")
        end

        it "it should require content" do
           post = @user.microposts.build({:content => ""})
           post.should_not be_valid
        end

        it "it should not allow posts longer than 140 characters" do
           post = @user.microposts.build({:content => "x" * 141})
           post.should_not be_valid
        end

        it "it should allow posts with length >0 and < 141" do
           post = @user.microposts.build({:content => "x" * 120})
           post.should be_valid
        end
    end

    describe "from_users_followed_by" do

        before(:each) do
            @other_user = Factory(:user, :email => Factory.next(:email))
            @third_user = Factory(:user, :email => Factory.next(:email))

            @user_post  = @user.microposts.create!(:content => "foo")
            @other_post = @other_user.microposts.create!(:content => "bar")
            @third_post = @third_user.microposts.create!(:content => "baz")

            @user.follow!(@other_user)
        end

        it "should have a from_users_followed_by class method" do
            Micropost.should respond_to(:from_users_followed_by)
        end

        it "should include the followed user's microposts" do
            Micropost.from_users_followed_by(@user).should include(@other_post)
        end

        it "should include the user's own microposts" do
            Micropost.from_users_followed_by(@user).should include(@user_post)
        end

        it "should not include an unfollowed user's microposts" do
            Micropost.from_users_followed_by(@user).should_not include(@third_post)
        end
    end

end
