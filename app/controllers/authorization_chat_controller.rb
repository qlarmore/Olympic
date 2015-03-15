# class AuthorizationChatController < WebsocketRails::BaseController
#   def authorize_channels
#     # The channel name will be passed inside the message Hash
#     channel = message[:channel]

#     Rails.logger.info "Vesya connected #{current_user.id} - #{channel}"

#     case channel
#     when "message_count_#{current_user.id}"
#       accept_channel current_user
#     else
#       if current_user.can_write_to_channel?(channel)
#         accept_channel current_user
#       else
#         deny_channel({:message => t("errors.messages.auth_failed")})
#       end
#     end
#   end
# end