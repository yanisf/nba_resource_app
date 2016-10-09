class CommentsController < ApplicationController
	before_action :signed_in_user
	
	def create
		@article = Article.find(params[:article_id])
		@comment = @article.comments.build(comment_params)
		if @comment.save
			flash[:success] = "Comment is added!"
		end
		redirect_to article_path(@article)
	end
	
	def destroy
		@article = Article.find(params[:article_id])
		@comment = @article.comments.find(params[:id])
		@comment.destroy
		flash[:success] = "Comment deleted"
		redirect_to article_path(@article)
	end
	private
		def comment_params
			params.require(:comment).permit(:body).merge(user_id: current_user.id)
		end
end
