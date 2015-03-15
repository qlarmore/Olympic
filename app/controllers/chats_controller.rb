class ChatsController < ApplicationController

  def create
    @message = current_user.reply_to_conversation(params[:conversation_id], resource_params)
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
      # $redis ||= Redis.new(:host => 'localhost', :port=> 6379)
      # PrivatePub.publish_to("/messages/#{@message.conversation.id}", { msg_body: render_to_string(partial: "/messages/message", layout: false, locals: { message: @message }) })
      $redis.publish 'rt-change', { channel: "/messages/#{@message.conversation.id}", data: { msg_body: render_to_string(partial: "/messages/message", layout: false, locals: { message: @message }), id: @message.user.id } }.to_json

      @message.conversation.users.where.not(id: current_user.id).each do |user|
        if user.chatting?(@message.conversation)
          @message.mark_as_read!(user)
        else
          # PrivatePub.publish_to "/message/#{user.id}", { data: [{ target: '.message-count', html: "#{user.unread_messages_count}<audio autoplay><source src='#{asset_path('message1.mp3')}' type='audio/mpeg'></source></audio>" }, { target: ".count-box#conversation_#{@message.conversation.id}", html: render_to_string(partial: 'messages/message_con_count', locals: { conversation: @message.conversation, user: user }) }] }
          $redis.publish 'rt-change', { channel: "/message/#{user.id}", data: { data: [{ target: '.message-count', html: "#{user.unread_messages_count}<audio autoplay><source src='#{asset_path('message1.mp3')}' type='audio/mpeg'></source></audio>" }, { target: ".count-box#conversation_#{@message.conversation.id}", html: render_to_string(partial: 'messages/message_con_count', locals: { conversation: @message.conversation, user: user }) }] }}.to_json
        end
      end
      render json: { success: true}, content_type: "text/plain"
    else
      render json: { success: false, error: t("error.messages.standart") }, content_type: "text/plain"
    end
  end

  private
  
  def resource_params
    request.get? ? {} : params.require(:message).permit!
  end

end

# class ChatController < WebsocketRails::BaseController
#   include ActionView::Helpers::SanitizeHelper

#   def initialize_session
#     puts "Session Initialized\n"
#   end
  
#   def system_msg(ev, msg)
#     broadcast_message ev, { 
#       # user_name: 'system', 
#       # received: Time.now.to_s(:short), 
#       msg_body: msg
#     }
#   end
  
#   def user_msg(ev, msg)
#     broadcast_message ev, { 
#       # user_name:  "connection_store[:user][:user_name]", 
#       # received:   Time.now.to_s(:short), 
#       msg_body:   msg
#       }

#   end
  
#   def client_connected
#     # current_user.update_column({ last_activity: nil }) if current_user
#   end

#   def client_disconnected
#     # current_user.update_column({ last_activity: Time.now }) if current_user
#   end
  
#   def new_message
#     p "new message"
#     Rails.logger.info "message: #{message.inspect}"
#     resource_params = message[:msg_body]
#     current_user = User.where(nick_name: 'admin').first
#     binding.pry
#     @message = current_user.reply_to_conversation(message[:msg_body][:conversation_id], resource_params[:message])
#     if @message.errors.empty?
#       if resource_params[:assets]
#         if resource_params[:assets][:avatar_uids]
#           f = AvatarUploader.new
#           resource_params[:assets][:avatar_uids].each do |avatar_id|
#             f.retrieve_from_cache!(avatar_id)
#             Asset.create(message_id: @message.id, avatar: f)
#           end
#         end
#       end
#       # user_msg :new_message, render_to_string(partial: "/messages/message", layout: false, locals: { message: @message })
#       WebsocketRails["#{@message.conversation.id}"].trigger "new_message", { msg_body: render_to_string(partial: "/messages/message", layout: false, locals: { message: @message }) }
#       @message.conversation.users.where.not(id: current_user.id).each do |user|
#         if user.chatting?(@message.conversation)
#           @message.mark_as_read!(user)
#         else
#           WebsocketRails["message_count_#{user.id}"].trigger "message_count", [{ target: '.message-count', html: "#{user.unread_messages_count}<audio autoplay><source src='#{asset_path('message1.mp3')}' type='audio/mpeg'></source></audio>" }, { target: ".count-box#conversation_#{@message.conversation.id}", html: render_to_string(partial: 'messages/message_con_count', locals: { conversation: @message.conversation, user: user }) }]
#         end
#       end
#       # render json: { success: true,  html: render_to_string(partial: "/messages/message", layout: false, locals: { message: @message }) }
#     else
#       # render json: { success: false,  error: @message.errors.full_messages }
#     end

#     # user_msg :new_message, message[:msg_body].dup
#   end
  
#   # def new_user
#   #   connection_store[:user] = { user_name: sanitize(message[:user_name]) }
#   #   broadcast_user_list
#   # end
  
#   # def change_username
#   #   connection_store[:user][:user_name] = sanitize(message[:user_name])
#   #   broadcast_user_list
#   # end
  
#   # def delete_user
#   #   connection_store[:user] = nil
#   #   system_msg "client #{client_id} disconnected"
#   #   broadcast_user_list
#   # end
  
#   # def broadcast_user_list
#   #   users = connection_store.collect_all(:user)
#   #   broadcast_message :user_list, users
#   # end
  
# end
