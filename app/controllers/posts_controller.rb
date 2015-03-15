class PostsController < ApplicationController
  helper_method :resource

  layout false

  before_filter :check_permition
  before_filter :find_post, only: [ :destroy, :restore, :edit, :update ]

  
  def create
    @post = resource.posts.new(resource_params.merge(user_id: current_user.id))
    if @post.save
      if params[:assets]
        if params[:assets][:avatar_uids]
          f = AvatarUploader.new
          params[:assets][:avatar_uids].each do |avatar_id|
            f.retrieve_from_cache!(avatar_id)
            Asset.create(post_id: @post.id, avatar: f)
          end
        end
      end
      if @post.comment?
        render json: { success: true,  items: [{ html: render_to_string(partial: "/posts/post", layout: false, locals: { post: @post }), target: "#comment_content_#{@post.parent.id}", show_method: "append" }, { html: "(#{@post.parent.comments.size})", target: "#comment-count-#{@post.parent.id}", show_method: "html" }] }
      else
        render json: { success: true,  html: render_to_string(partial: "/posts/post", layout: false, locals: { post: @post }) }
      end
    else
      render json: { success: false,  error: @post.errors.full_messages }
    end
  end

  def edit
    render json: { success: true, html: render_to_string(partial: 'edit', locals: { post: @post, global: params[:global] }) }
  end

  def update
    if @post.update_attributes(resource_params)
      if params[:assets]
        if params[:assets][:avatar_ids]
          @post.assets.where.not(id: params[:assets][:avatar_ids]).delete_all
        end

        if params[:assets][:avatar_uids]
          f = AvatarUploader.new
          params[:assets][:avatar_uids].each do |avatar_id|
            f.retrieve_from_cache!(avatar_id)
            Asset.create(post_id: @post.id, avatar: f)
          end
        end
      else
        @post.assets.delete_all
      end
      if params[:global].present?
        render json: { success: true,  html: render_to_string(partial: "/posts/global_post", layout: false, locals: { post: @post }) }
      else
        render json: { success: true,  html: render_to_string(partial: "/posts/post", layout: false, locals: { post: @post }) }
      end
    else
      render json: { success: false,  error: @post.errors.full_messages }
    end
  end

  def like
    @post = Post.find_by_id(params[:id])
    current_user.likes(@post)
    render json: { success: true, html: render_to_string(partial: 'like', locals:{post: @post})} 
  end

  def dislike
    @post = Post.find_by_id(params[:id])
    current_user.dislikes(@post)
    render json: { success: true, html: render_to_string(partial: 'like', locals:{post: @post})} 
  end

  def destroy
    if @post.destroy
      render json: { success: true, html: render_to_string(partial: 'destroy_post', locals: { post: @post, global: params[:global] }), messages: t("success.messages.destroyed") }  
    else
      render json: { success: false, error: @post.errors.full_messages }  
    end
  end

  def restore
    Post.restore(@post.id)
    if params[:global]
      render json: { success: true, html: render_to_string(partial: 'global_post', locals: { post: @post }), messages: t("success.messages.restore") }
    else
      render json: { success: true, html: render_to_string(partial: 'post', locals: { post: @post }), messages: t("success.messages.restore") }
    end
  end


  private

    def check_permition
      render json: { success: false } unless current_user.try(:can_write_create_post?, resource)
    end

    def find_post
      @post = Post.with_deleted.find_by_id(params[:id])
      render json: { success: false } unless current_user.try(:is_post_creator?, @post)
    end

    def resource_params
      request.get? ? {} : params.require(:post).permit!
    end

    def resource
      Group.find_by_id(params[:group_id]) || User.find_by_id(params[:user_id])
    end

end
