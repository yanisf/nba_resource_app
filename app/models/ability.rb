class Ability
	include CanCan::Ability
	
	def initialize(user)
		user ||= User.new
		
		if user.admin?
			can :manage, :all
		else
			can :read, Article, :all
			can :delete, Article, :user_id => user.id
			can :delete, Comment, :user_id => user.id
		end
	end	
	
	def current_ability
		@current_ability ||= Ability.new(current_user)
	end
end
