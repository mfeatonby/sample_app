require 'spec_helper'

describe "Users" do

  describe "GET /users" do

    it "should be able to capture a valid user" do
      visit signup_path
      fill_in "Name", :with => "TestName"
      fill_in "Email", :with => "email@address.com"
      fill_in "Password", :with => "password"
      fill_in "Password Confirmation", :with => "password"
      click_button

      response.status.should be(200)
      response.should render_template("users/new")
      response.should have_selector("div.flash.success")
    end

    it "should report errors correctly" do
      visit signup_path
      fill_in "Name", :with => ""
      fill_in "Email", :with => "@address.com"
      fill_in "Password", :with => ""
      fill_in "Password Confirmation", :with => ""
      click_button

      response.status.should be(200)
      response.should render_template("users/new")
      response.should have_selector("div#error_explanation")

    end

    it "should capture the new user in the database" do
      lambda do
        visit signup_path
        fill_in "Name", :with => "TestingTesting"
        fill_in "Email", :with => "email2@address.com"
        fill_in "Password", :with => "password"
        fill_in "Password Confirmation", :with => "password"
        click_button

        response.status.should be(200)
        response.should render_template("users/new")
        response.should have_selector("div.flash.success")
      end.should change(User, :count).by(1)
    end
    
  end
end
