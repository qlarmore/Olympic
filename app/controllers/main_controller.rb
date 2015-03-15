class MainController < ApplicationController

  def index
    @top_posts = Post.top.page(params[:page] || 1).per(10)
  end

end