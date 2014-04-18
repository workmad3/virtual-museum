class CommentsController < ApplicationController

  def create
    @page = Page.find_by_slug(params['page_id'])
    @comment = @page.comments.create(user: current_user,
                                     commenter: params[:comment][:commenter],
                                     content: params[:comment][:content]  )
    redirect_to page_path(@page)
  end

  def index
  end

  def page_params
    params.require(:comment).permit(:commenter, :content, :user, :page)
    params.require(:page).permit(:commenters)
  end
end