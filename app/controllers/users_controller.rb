class UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :admin_user,     only: :destroy
	before_action :correct_user,   only: [:show, :destroy]
	
	def show
	end
				
	def index
		@users = User.paginate(page: params[:page])
	end
	
	def destroy
		@user.destroy
		flash[:success] = "User deleted."
		redirect_to users_url
	end
	
	private		
		# Before filters
			
		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end
		
		def correct_user
			@user = User.find(params[:id])
		end
end
