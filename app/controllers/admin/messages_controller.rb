class Admin::MessagesController < Admin::BaseController
  inherit_resources

  def index
    @messages = Message.all
  end

  def update
    @message =Message.find_by_id(params[:id])
    if @message.update_attributes(resource_params)
      redirect_to admin_messages_path
    else
      render json: { success: false,  error: @message.errors.full_messages }
    end
  end

  private

  def resource_params
    request.get? ? {} : params.require(:message).permit!
  end

end
