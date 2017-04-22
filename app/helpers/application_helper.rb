module ApplicationHelper
	# Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = "NBA Resource App"
		if page_title.empty?
			base_title
			else
			"#{base_title} | #{page_title}"
		end
	end
	
	def article_params
		params.require(:article).permit(:title, :content)
	end
end
