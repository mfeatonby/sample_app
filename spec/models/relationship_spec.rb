require 'spec_helper'

describe Relationship do

    before (:each) do
        @follower = Factory(:user)
        @followed = Factory(:user, :email => Factory.next(:email))

        @relationship = @follower.relationships.build(:followed_id => @followed.id)

    end

    it "should be able to save a relationship between two users" do
        @relationship.save!
    end

    describe "follow methods" do

        before(:each) do
            @relationship.save
        end

        it "should have a follower attribute" do
            @relationship.should respond_to(:follower)
        end

        it "should have the right follower" do
            @relationship.follower.should == @follower
        end

        it "should have a followed attribute" do
            @relationship.should respond_to(:followed)
        end

        it "should have the right followed user" do
            @relationship.followed.should == @followed
        end
    end

    describe "validation rules" do

        it "should require a follower" do
            @relationship.follower = nil
            @relationship.should_not be_valid
        end

        it "should require a followed" do
           @relationship.followed = nil
           @relationship.should_not be_valid
        end
    end

end
