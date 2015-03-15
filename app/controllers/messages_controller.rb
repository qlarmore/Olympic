class MessagesController < ApplicationController
  # require "websocket-rails"
  
  def index
    @conversations = current_user.conversations
  end

  def show
    @conversation = current_user.conversations.find_by_id(params[:id])
  end

  def create
    @message = current_user.send_message(params[:user_ids], resource_params.merge(user_id: current_user.id))
    if @message.errors.empty?
      if params[:assets]
        if params[:assets][:avatar_uids]
          f = AvatarUploader.new
          params[:assets][:avatar_uids].each do |avatar_id|
            f.retrieve_from_cache!(avatar_id)
            Asset.create(message_id: @message.id, avatar: f)
          end
        end
      end
      # PrivatePub.publish_to("/messages/#{@message.conversation.id}", { msg_body: render_to_string(partial: "/messages/message", layout: false, locals: { message: @message }) })
      # $redis ||= Redis.new(:host => 'localhost', :port=> 6379)
      $redis.publish 'rt-change', { channel: "/messages/#{@message.conversation.id}", data: { msg_body: render_to_string(partial: "/messages/message", layout: false, locals: { message: @message }), id: @message.user.id } }.to_json
      @message.conversation.users.where.not(id: current_user.id).each do |user|
        if user.chatting?(@message.conversation)
          @message.mark_as_read!(user)
        else
          # PrivatePub.publish_to "/message/#{user.id}", [{ target: '.message-count', html: "#{user.unread_messages_count}<audio autoplay><source src='#{asset_path('message1.mp3')}' type='audio/mpeg'></source></audio>" }, { target: ".count-box#conversation_#{@message.conversation.id}", html: render_to_string(partial: 'messages/message_con_count', locals: { conversation: @message.conversation, user: user }) }]
          $redis.publish 'rt-change', { channel: "/message/#{user.id}", data: { data: [{ target: '.message-count', html: "#{user.unread_messages_count}<audio autoplay><source src='#{asset_path('message1.mp3')}' type='audio/mpeg'></source></audio>" }, { target: ".count-box#conversation_#{@message.conversation.id}", html: render_to_string(partial: 'messages/message_con_count', locals: { conversation: @message.conversation, user: user }) }] }}.to_json
        end
      end
      render json: { success: true, message: t("success.messages.sent")}, content_type: "text/plain"
    else
      render json: { success: false, error: t("error.messages.standart") }, content_type: "text/plain"
    end
  end

  private
  
  def resource_params
    request.get? ? {} : params.require(:message).permit!
  end

end
