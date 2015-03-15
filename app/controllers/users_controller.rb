class UsersController < ApplicationController
  helper_method :resource

  before_filter :find_user , :only => [:invite_friend, :reject_friend]

  def set_locale
    if current_user
      current_user.update_column(:language, params[:locale])
      I18n.locale = current_user.language = params[:locale]
    else
      cookies[:locale] = params[:locale]
      I18n.locale = cookies[:locale]
    end
    redirect_to :root
  end
  
  def index
    @users = User.all
  end

  def show
    @user =User.find_by_id(params[:id])
  end

  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      redirect_to user_path
    else
      render 'edit'
    end
  end

  def complite
    @users = User.where("nick_name LIKE :search OR first_name LIKE :search OR last_name LIKE :search OR CONCAT_WS(' ', first_name, last_name) LIKE :search", search: "%#{params[:q].try(:strip)}%").where.not(id: current_user.id).last(10)
    render json: @users.as_json(only: [:id], methods: :full_name) 
  end

  def invite_friend
    current_user.add_to_friend(@user)
    render json: {success: true, message: "#{t("followed")}"}
  end

  def reject_friend
    current_user.remove_from_friend(@user)
    render json: {success: true, message: "#{t("unfollow")}"}
  end

  private

    def user_params
      params.require(:user).permit(:nick_name, :first_name, :last_name, :number, :birthday, :avatar, :show_status, :show_birthbay, :show_number, :invite_to_friend, :write_on_page, :comment_post, :write_private_message, :show_image)
    end

    def find_user
      @user = User.where("id = #{params[:id]}").not(current_user.id).first
      render json: { success: false, error: t("error.messages.standart") } unless @user
    end

    def resource
      User.find_by_id(params[:id])
    end
end
