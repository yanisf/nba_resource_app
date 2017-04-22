FactoryGirl.define do
	factory :user do
		sequence(:username)  { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com"}
		password "foobar12"
		password_confirmation "foobar12"
		
		factory :admin do
			admin true
		end
		
		factory :author do
			admin true
		end
	end
	
	factory :article do
		title "smth"
		content "Lorem ipsum"
		user
	end
end	