class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable,
		   :registerable,
		   :rememberable,
           :trackable,
           :validatable
	
	has_many :articles
	has_many :comments

	validates :username, presence: true, length: { maximum: 50 }
	validates :email, presence: true, email: true
end