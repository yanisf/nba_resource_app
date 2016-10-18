namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Admin User",
							 email: "admin@mail.ru",
							 password: "adminuser",
							 password_confirmation: "adminuser",
							 admin: true)
							 
		author = User.create!(name: "Author",
							 email: "author@mail.ru",
							 password: "author",
							 password_confirmation: "author",
							 admin: true)
		users = User.all
		5.times do |q|
			content = Faker::Lorem.sentence(5)
			title = Faker::Lorem.sentence(5)
			users.each { |user| user.articles.create!(title: title, content: content, created_at: (q+1).day.ago) }
		end
		
		99.times do |n|
			name  = Faker::Name.name
			email = "example-#{n+1}@mail.ru"
			password  = "password"
			User.create!(name: name,
					     email: email,
					     password: password,
					     password_confirmation: password)
		end	
		
		users = User.all(limit: 4)
		
		articles = Article.all
		users.each { |user|			
			user_id = user.id
			body = Faker::Lorem.sentence(5)
			articles.each { |article| article.comments.create!(body: body, user_id: user_id) }			
		}
	end
end