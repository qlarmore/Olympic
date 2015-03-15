$ ->
  $.hide_post_form = ->
    $('.message-area').css('height', 30) 
    $('.message-area').clearInputs() 
    $('.message-area').closest('.post-form').find('.option-box').hide()
    $('.upload-avatar').remove()

  $.clear_chat_form = ->
    $('.chat-area').clearInputs() 
    $('.upload-avatar').remove()

  $.hide_comment_form = ->
    $('.comment-form').hide()

  $(document).on "focus", ".message-area", ->
    console.log('open form option')
    $(this).closest('.post-form').find('.option-box').show()
    $(this).css('height', 120)
    false

  $(document).on 'click', '.upload-avatar .close', ->
    $(this).parents('.upload-avatar').remove()

  $(document).on 'click', '.comment-link', ->
    console.log($(this).parents('.post-box').find('.comment-form'))
    $(this).parents('.post-box').find('.comment-form').show()

  $(document).on "click", (event) ->
    return if $(event.target).hasClass('close')
    if (!$(event.target).closest(".post-form").length)
      $.hide_post_form()
    if (!$(event.target).closest(".comment-form").length and !$(event.target).closest(".option").length)
      $.hide_comment_form()

  $(document).on "change", ".avatar-choise", ->
    _this = this
    clossest = $(_this).closest('.post-form')
    console.log(clossest) 
    bar = clossest.find(".upload-file-progress .bar")
    percent = $(bar).find(".percent")
    clossest.find(".upload-file-progress").show()
    bar.width("0")
    percent.html("0%")

    clossest.find(".upload-form").ajaxSubmit
      dataType: "json"
      uploadProgress: (event, position, total, percentComplete) -> 
          percentVal = percentComplete + '%' 
          bar.width(percentVal)
          percent.html(percentVal) 
      complete: (xhr) ->
        percentVal = '100%' 
        bar.width(percentVal) 
        percent.html(percentVal)
        $(_this).val('')
        clossest.find(".upload-file-progress").hide()
      success: (data) ->
        if data.success
          $.each data.images, (i, u) ->
            clossest.find('.image-attach-box')
              .append($('<div>').addClass("upload-avatar")
              .append($('<img>').attr("src", u))
              .append($('<i>').addClass("fa fa-times close"))
              .append($('<input type="text" name="assets[avatar_uids][]">').val(data.uids[i]).addClass("hide")))
        else
          if data.error
            $.show_message(data.error)
        if data.message
          $.show_message(data.message)
      error: (xhr, textStatus, errorThrown) ->
        $.gritter.add({
          title: 'Error',
          text: 'Sorry, but someting went wrong!',
          image: '/assets/error.png'
        })
