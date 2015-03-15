class InvitationsController < ApplicationController
  before_filter :type
  def index
    @users = current_user.friends(type).search(params[:search])
    respond_to do |format|
      format.html 
      format.js {render json: { success: true, html: render_to_string(partial: type, collection: @users, as: :user)}}
    end
  end
  
  private

  def type
    @type ||= Invitation::TYPE.include?(params[:type]) ? params[:type] :  Invitation::TYPE.first
  end

end
