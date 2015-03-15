class Admin::UsersController < Admin::BaseController
  inherit_resources

  def index
    @users = User.all
  end
  
  def login
    @user = User.find(params[:user_id])
    sign_in  @user
    redirect_to root_path
  end

  def update
    @user =User.find_by_id(params[:id])
    if @user.update_attributes(resource_params)
      redirect_to admin_users_path
    else
      render json: { success: false,  error: @user.errors.full_messages }
    end
  end

  private

  def resource_params
    request.get? ? {} : params.require(:user).permit!
  end

end
