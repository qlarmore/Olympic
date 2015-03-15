class Admin::GroupsController < Admin::BaseController
  inherit_resources

  def index
    @groups = Group.all
  end

  def update
    @group =Group.find_by_id(params[:id])
    if @group.update_attributes(resource_params)
      redirect_to admin_groups_path
    else
      render json: { success: false,  error: @group.errors.full_messages }
    end
  end

  private

  def resource_params
    request.get? ? {} : params.require(:group).permit!
  end

end
