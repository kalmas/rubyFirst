require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
  
    it { should have_selector('h1',    text: user.name_pretty) }
    it { should have_selector('title', text: user.name_pretty) }
  end
  
  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_selector('.alert-error', text: /The form contains \d errors./) }
        it { should have_content('Password can\'t be blank') }
        it { should have_content('Username can\'t be blank') }
        it { should have_content('Email can\'t be blank') }
        it { should have_content('Email is invalid') }
        it { should have_content('Password is too short') }
        it { should have_content('Password confirmation can\'t be blank') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Username",     with: "Expl_Usr"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }
  
        it { should have_selector('title', text: user.name_pretty) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }   
      end

    end
  end
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end
  
    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end
  
    describe "with invalid information" do
      before { click_button "Save changes" }
  
      it { should have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_pass)  { "oh!nicepassword" }
      before do
        fill_in "Password",         with: new_pass
        fill_in "Confirm Password", with: new_pass
         click_button "Save changes"
      end
          
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
    end
  end
  
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    
    before(:each) do
      sign_in user
      visit users_path
    end
    
    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }
    
    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
  end
end

