class ArticlesController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy, :edit, :update]
	before_action :correct_user,   only: :destroy
	before_action :admin_user,     only: [:new, :create, :destroy, :edit, :update]
	
	def index
		@articles = Article.all
		@articles_by_day = @articles.order("created_at DESC").group_by{ |article| article.created_at.to_date }
	end
	
	def new
		@article = current_user.articles.build
		@feed_items = current_user.feed.paginate(page: params[:page])
	end
	
	def create
		@article = current_user.articles.build(article_params)
		@feed_items = current_user.feed.paginate(page: params[:page])
		if @article.save
			flash[:success] = "Article is published!"
			redirect_to management_url
		else
			render 'articles/new'
		end
	end
	
	def edit
		@feed_item = Article.find(params[:id])
	end
	
	def update
		@article = Article.find(params[:id])
		if @article.update_attributes(article_params)
			flash[:success] = "Article updated"
			redirect_to management_url
		else
			render 'edit'
		end
	end
	
	def destroy
		Article.find(params[:id]).destroy
		flash[:success] = "Article deleted"
		redirect_to management_url
	end
	
	def show
		@article = Article.find(params[:id])
		@comment = @article.comments.build
	end
	
	
	def help
	end
	
	def about
	end
	
	def contact
	end
	
	private	
		def article_params
			params.require(:article).permit(:title, :content)
		end
		
		def correct_user
			@article = current_user.articles.find_by(id: params[:id])
			redirect_to management_url if @article.nil?
		end
		
		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end
end
