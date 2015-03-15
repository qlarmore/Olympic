class AssetsController < ApplicationController
  layout false

  def create
    @uids = []
    @images = []

    begin
      f = AvatarUploader.new
      params[:assets][:avatar].each do |avatar|
        f.cache!(avatar)
        @uids << f.cache_name
        @images << f.url
      end
      render json: { success: true, uids: @uids, images: @images }, content_type: "text/plain"
    rescue Exception => e
      render json: { success: false,  error: e.message }, content_type: "text/plain"
    end
  end

  private

    def resource_params
      request.get? ? {} : params.require(:post).permit!
    end

end