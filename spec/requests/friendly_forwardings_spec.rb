require 'spec_helper'

describe "FriendlyForwardings" do

    before(:each) do
      @attr = {:name => "Malcolm", :email => "email@example.com", :password => "password", :password_confirmation => "password"}
      @user = User.create!(@attr)
      User.stub!(:find, @user.id).and_return(@user)
      User.stub!(:find_by_email, @user.email).and_return(@user)
    end

    it "should redirect to the appropriate page after signin" do

        visit edit_user_path(@user)

        fill_in :email, :with => @attr[:email]
        fill_in :password, :with => @attr[:password]
        click_button

        response.should render_template('users/edit')

    end

end
