require 'spec_helper'

describe Comment do
	let(:user) { FactoryGirl.create(:user) }
	let(:article) { FactoryGirl.create(:article) }
	
	before { @comment = article.comments.build(body: "WOW", user_id: user.id) } 
	
	subject { @comment }
	
	it { should respond_to(:body) }
	it { should respond_to(:user_id) }
	it { should respond_to(:article) }
	its(:article) { should eq article }
	
	describe "when user_id is not present" do
		before { @comment.user_id = nil }
		it { should_not be_valid }
	end
	
	describe "with blank body" do
		before { @comment.body = " " }
		it { should_not be_valid }
	end
end
