class CommentsController < ApplicationController
	before_action :current_article
	
	def create		
		@comment = @article.comments.build(comment_params)
		if @comment.save
			flash[:success] = "Comment is added!"
			redirect_to article_path(@article)
		end
	end
	
	def destroy
		@comment = @article.comments.find(params[:id])
		@comment.destroy
		flash[:success] = "Comment deleted"
		redirect_to article_path(@article)
	end
	
	private
		def comment_params
			params.require(:comment).permit(:body).merge(user_id: current_user.id)
		end
		
		def current_article
			@article = Article.find(params[:article_id])
		end
end
