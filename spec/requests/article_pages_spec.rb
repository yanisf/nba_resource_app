require 'spec_helper'

describe "Article pages" do
	
	subject { page }
	
	describe "ROOT Index page" do	
		before { visit root_path }
		
		it { should have_title('All News')}
		it { should have_content('All News') }
		it { should have_content('nba app') }
	end

	describe "Help page" do	
		before { visit help_path }
		
		it { should have_title('Help')}
		it { should have_content('Help') }
	end	

	describe "Article Management page" do
		let(:user) { FactoryGirl.create(:user) }
		
		let!(:a1) { FactoryGirl.create(:article, user: user, title: "smth1", content: "Foo") }
		let!(:a2) { FactoryGirl.create(:article, user: user, title: "smth2", content: "Bar") }
		
		before do 
			sign_in user 
			visit management_path
		end
		
		it { should have_title('Management')}
		
		describe "articles titles view" do
			it { should have_content(a1.title) }
			it { should have_content(a2.title) }
		end
		
		it "should render the user's feed" do
			user.feed.each do |item|
				expect(page).to have_selector("li##{item.id}", text: item.title)
			end
		end
		
		describe "delete articles" do
						
			describe "as an admin user" do
				let(:admin) { FactoryGirl.create(:admin) }
				let(:author) { FactoryGirl.create(:author) }
				
				let!(:a1) { FactoryGirl.create(:article, user: admin, title: "smth1", content: "Foo") }
				let!(:a2) { FactoryGirl.create(:article, user: author, title: "smth2", content: "Bar") }
				
				before do
					sign_in admin
					visit management_path
				end
								
				it { should have_link('delete', href: article_path(a1)) }
				it { should_not have_link('delete', href: article_path(a2)) }
								
				it "should delete an article" do
					expect { click_link "delete" }.to change(Article, :count).by(-1)
				end				
			end
		end
		
		describe "edit articles" do
			let(:admin) { FactoryGirl.create(:admin) }
			let!(:article) { FactoryGirl.create(:article, user: admin, title: "smth1", content: "Foo") }
			
			before do
				sign_in admin
				visit edit_article_path(article)
			end
			
			describe "page" do
				it { should have_content("Update your article") }
				it { should have_title("Edit article") }
			end
			
			describe "with invalid information" do
				before do
					fill_in "Title",          with: ""
					click_button "Publish"
				end	
				it { should have_content('error') }
			end
			
			describe "with valid information" do
				let(:new_title)  { "New Title" }
				let(:new_content) { "New Content" }
				
				before do
					fill_in "Title",            with: new_title
					fill_in "Content",          with: new_content
					click_button "Publish"
				end
				
				specify { expect(article.reload.title).to  eq new_title }
				specify { expect(article.reload.content).to eq new_content }
			end
		end 		
	end
end	
