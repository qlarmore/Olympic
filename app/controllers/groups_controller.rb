class GroupsController < ApplicationController
  # inherit_resources
  helper_method :resource

  def index
    @groups = Group.all.page(params[:page] || 1).per(10)
  end

  def create
    @group = current_user.groups.new(resource_params)
    if @group.save
      redirect_to group_path(@group), notice: 'Good'
    else
      render :new
    end
  end

  def show
    @group = Group.find_by_id(params[:id])
    @posts = @group.posts.page(params[:page] || 1).per(10)
  end

  def new
    @group = current_user.groups.new
  end

  def entry
    @group = Group.find_by_id(params[:id])
    if current_user.is_creator?(@group)
      redirect_to root_path
    else
      @group.users << current_user
      redirect_to group_path(@group)
    end
  end

  def exit
    @group = Group.find_by_id(params[:id])
    if current_user.is_creator?(@group)
      redirect_to root_path
    else
      @group.group_users.where(user_id: current_user.id, group_id: @group.id).first.delete
      redirect_to group_path(@group)
    end
  end

  private
    def resource_params
      request.get? ? {} : params.require(:group).permit!
    end

    def resource
      Group.find_by_id(params[:id])
    end
end