require 'spec_helper'

describe "User pages" do
	
	subject { page }
	
	describe "index" do
		let(:user) { FactoryGirl.create(:user) }
		
		before do
			sign_in(user)
			visit users_path
		end
		
		it { should have_title('All users') }
		it { should have_content('All users') }
		
		describe "pagination" do
			
			before(:all) { 30.times { FactoryGirl.create(:user) } }
			after(:all)  { User.delete_all }
			
			it { should have_selector('div.pagination') }
			
			it "should list each user" do
				User.paginate(page: 1).each do |user|
					expect(page).to have_selector('li', text: user.username)
				end
			end
		end
		
		describe "delete links" do
			
			it { should_not have_link('delete') }
			
			describe "as an admin user" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					sign_in(admin)
					visit users_path
				end
				
				it { should have_link('delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect do
						click_link('delete', match: :first)
					end.to change(User, :count).by(-1)
				end
				it { should_not have_link('delete', href: user_path(admin)) }
			end
		end
	end
	
	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in(user)
			visit user_path(user)
		end
		
		it { should have_content(user.username) }
		it { should have_title(user.username) }
	end
	
	describe "signup page" do
		before { visit new_user_registration_path }
		
		it { should have_content('Sign up') }
		it { should have_title(full_title('Sign up')) }
	end
	
	describe "signup page" do
		
		before { visit new_user_registration_path }
		
		let(:submit) { "Sign up" }
		
		describe "with invalid information" do
			describe "after submission" do
				before { click_button submit }
				
				it { should have_title('Sign up') }
				it { should have_content('error') }
				it { should have_content('prohibited this user from being saved') }
			end
			
			
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end
		
		describe "with valid information" do
			before do
				fill_in "Username",         with: "Example User"
				fill_in "Email",        with: "user@example.com"
				fill_in "Password",     with: "foobar123"
				fill_in "Password confirmation", with: "foobar123"
			end
			
			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end
			
			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by(email: 'user@example.com') }
				
				it { should have_link('Sign out') }
				it { should have_selector('div.alert.alert-notice', text: 'Welcome! You have signed up successfully.') }
			end
		end
	end
	
	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in(user)
			visit edit_user_registration_path(user)
		end
		
		describe "page" do
			it { should have_title("Edit User") }
		end
		
		describe "with invalid information" do
			before { click_button "Save changes" }
			
			it { should have_content('error') }
		end
		
		describe "with valid information" do
			let(:new_name)  { "New Name" }
			let(:new_email) { "new@example.com" }
			before do
				fill_in "Username",             with: new_name
				fill_in "Email",            with: new_email
				fill_in "Current password",         with: user.password
				click_button "Save changes"
			end
			
			it { should have_title('All News') }
			it { should have_selector('div.alert.alert-notice') }
			it { should have_link('Sign out', href: destroy_user_session_path) }
			specify { expect(user.reload.username).to  eq new_name }
			specify { expect(user.reload.email).to eq new_email }
		end
	end 
end		