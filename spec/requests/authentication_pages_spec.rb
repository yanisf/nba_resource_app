require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit new_user_session_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-alert') }
	
	  describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-alert') }
      end
    end
	
	describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
		sign_in(user)
		visit user_path(user)
	  end

	  it { should have_link('Users',       href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
	  it { should have_link('Settings',    href: edit_user_registration_path(user)) }
      it { should have_link('Sign out',    href: destroy_user_session_path) }
      it { should_not have_link('Sign in', href: new_user_session_path) }
	  
	  describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end
  
  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
	  
	  describe "when attempting to visit a protected page" do
        before do
          visit users_path
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('All users')
          end
        end
      end
	  
      describe "in the Users controller" do

        describe "visiting the all users page" do
          before { visit edit_user_registration_path(user) }
          it { should have_content('You need to sign in or sign up before continuing') }
        end
		
		describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
      end
    end
  end
end
