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

end
