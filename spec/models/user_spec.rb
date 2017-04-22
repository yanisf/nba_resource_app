require 'spec_helper'

describe User do
	
	before do
		@user = User.new(username: "Example User", email: "user@example.com",
		password: "foobar12", password_confirmation: "foobar12")
	end
	
	subject { @user }
	
	it { should respond_to(:username) }
	it { should respond_to(:email) }
	it { should respond_to(:encrypted_password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:admin) }
	it { should respond_to(:articles) }
	
	it { should be_valid }
	it { should_not be_admin }
	
	describe "with admin attribute set to 'true'" do
		before do
			@user.save!
			@user.toggle!(:admin)
		end
		
		it { should be_admin }
	end
	
	describe "when username is not present" do
		before { @user.username = " " }
		it { should_not be_valid }
	end
	
	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end
	
	describe "when username is too long" do
		before { @user.username = "a" * 51 }
		it { should_not be_valid }
	end
	
	
	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
			foo@bar_baz.com foo@bar+baz.com foo@bar..com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				expect(@user).not_to be_valid
			end
		end
	end
	
	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end
	
	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.save
		end
		
		it { should_not be_valid }
	end
	
	describe "email address with mixed case" do
		let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
		
		it "should be saved as all lower-case" do
			@user.email = mixed_case_email
			@user.save
			expect(@user.reload.email).to eq mixed_case_email.downcase
		end
	end
	
	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end
	
	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end
	
	describe "article associations" do
		
		before { @user.save }
		let!(:older_article) do
			FactoryGirl.create(:article, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_article) do
			FactoryGirl.create(:article, user: @user, created_at: 1.hour.ago)
		end
		
		it "should have the right articles in the right order" do
			expect(@user.articles.to_a).to eq [newer_article, older_article]
		end
	end
end