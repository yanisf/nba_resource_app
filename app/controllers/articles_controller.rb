class ArticlesController < ApplicationController
	before_action :authenticate_user!,     except: [:show, :index, :help]
	before_action :correct_user,   only: :destroy
	before_action :admin_user,     only: [:new, :create, :destroy, :edit, :update]
	before_action :current_article, only: [:show, :edit, :update, :destroy]
	before_action :feed_articles, only: [:new, :create]
		
	def index
		@articles = Article.all
		@articles_by_day = @articles.order("created_at DESC").group_by{ |article| article.created_at.to_date }
	end
	
	def new
		@article = current_user.articles.build
	end
	
	def create
		@article = current_user.articles.build(article_params)
		if @article.save
			flash[:success] = "Article is published!"
			redirect_to management_url
		else
			render 'articles/new'
		end	
	end
	
	def edit
	end
	
	def update
		if @article.update_attributes(article_params)
			flash[:success] = "Article updated"
			redirect_to management_url
		else
			render 'edit'
		end
	end
	
	def destroy
		@article.destroy
		flash[:success] = "Article deleted"
		redirect_to management_url
	end
	
	def show
		@comment = @article.comments.build
	end
	
	def help
	end
	
	def about
	end
	
	def contact
	end
	
	private
		def current_article
			@article = Article.find(params[:id])
		end
		
		def feed_articles
			@feed_items = current_user.articles.paginate(page: params[:page])
		end
		
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
