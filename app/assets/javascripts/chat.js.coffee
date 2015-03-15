# window.Chat = {}

# class Chat.MessageController
#   constructor: (options) ->
#     @options = options
#     @init @options

#   init: (options) =>
#     @dispatcher = new WebSocketRails(options.url, true)
#     @message_count_channel = @dispatcher.subscribe_private(options.message_count_channel)
#     @bindEvents()

#   bindEvents: =>
#     @dispatcher.on_close = @reconect
#     @dispatcher.on_error = @reconect
#     @dispatcher.bind 'connection_closed', @reconect
#     @message_count_channel.bind 'message_count', @messageCount

#   reconect: =>
#     console.log("reconect")
#     @init @options

#   messageCount: (message) =>
#     $.each message, (i, m) ->
#       console.log(m)
#       $(m.target).html(m.html) if m


# class Chat.Controller

#   constructor: (options) ->
#     @options = options
#     @init @options

#   init: (options) =>
#     @dispatcher = new WebSocketRails(options.url, true)
#     @message_channel = @dispatcher.subscribe_private(options.message_channel)
#     @message_targget = $(options.message_targget)
#     @message_submit = $(options.message_submit)
#     @message_form = $(options.message_form)
#     @bindEvents()

#   bindEvents: =>
#     @dispatcher.on_close = @reconect
#     @dispatcher.on_error = @reconect
#     @dispatcher.bind 'connection_closed', @reconect
#     @message_channel.bind 'new_message', @newMessage
#     @message_submit.on 'click', @sendMessage
#     $('.messages').scrollTop($('.messages')[0].scrollHeight + 100)

#   reconect: =>
#     console.log("reconect")
#     @init @options

#   newMessage: (message) =>
#     @appendMessage message

#   sendMessage: (event) =>
#     console.log('send message')
#     event.preventDefault()
#     message = @message_form.serializeJSON()
#     @dispatcher.trigger 'new_message', {msg_body: message}
#     console.log(@dispatcher)
#     console.log("end send")
#     $.clear_chat_form() if @message_form

#   appendMessage: (message) ->
#     @message_targget.append message.msg_body if @message_targget
#     $('.messages').scrollTop($('.messages')[0].scrollHeight + 100)
