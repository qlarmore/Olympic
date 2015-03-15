class Admin::PostsController < Admin::BaseController
  inherit_resources

  def index
    @posts = Post.all
  end

  def update
    @post =Post.find_by_id(params[:id])
    if @post.update_attributes(resource_params)
      redirect_to admin_posts_path
    else
      render json: { success: false,  error: @post.errors.full_messages }
    end
  end

  private

  def resource_params
    request.get? ? {} : params.require(:post).permit!
  end

end
