$ ->
  $timer = undefined
  $.add_data = (data, target, show_method) ->
    switch show_method
      when "append"
        target.append(data)
      when "html"
        target.html(data)
      when "remove"
        target.remove()
      when "replace"
        target.replaceWith(data)
      else
        target.prepend(data)

  $.show_message = (msg) ->
    if (typeof msg is 'string')
      $.gritter.add({
        title: " ",
        text: msg,
        image: '/assets/notice.png'
      })
    else
      $.each msg, (i,m) ->
        $.gritter.add({
          title: " ",
          text: m,
          image: '/assets/notice.png'
        })

  $(document).on 'click', '.btn_js',->
    _this = $(this)
    url = $(this).data('action')
    type = $(this).data('method') || 'get'
    data = $(this).data('data')
    target = _this.data('target')
    show_method = _this.data('show-method')
    old_width = _this.width()
    old_height = _this.height()
    old_html = _this.html()
    _this.html($('<img>').attr("src", '/assets/btn-loader.gif')).width(old_width).height(old_height).removeClass('btn_js')
    window.history.replaceState("", "", url)
    $.ajax
      url: url
      type: type
      data: data
      dataType: 'json'
      success: (data) ->
        if data.success
          if data.items
            $.each data.items, (i, item) ->
              $.add_data(item.html, $(item.target), item.show_method)
          else
            if target
              $.add_data(data.html, $(target), show_method)
        else
          if data.error
            $.show_message(data.error)
        if data.message
          $.show_message(data.message)
        _this.html(old_html).addClass('btn_js')

      error: (xhr, textStatus, errorThrown) ->
        $.gritter.add({
          title: " ",
          text: textStatus,
          image: '/assets/error.png'
        })
        _this.html(old_html).addClass('btn_js')

  $(document).on 'click', '.btn_form_js', ->
    _this = $(this)
    closest = _this.closest('.post-form')
    form = closest.find('form')
    url = form.attr('action')
    type = form.attr('method')
    data = form.serialize()
    target = _this.data('target')
    close = _this.data('close')
    show_method = _this.data('show-method')
    submit_type = form.attr('enctype')
   
    old_width = _this.width()
    old_height = _this.height()
    old_html = _this.html()
    _this.html($('<img>').attr("src", '/assets/btn-loader.gif')).width(old_width).height(old_height).removeClass('btn_form_js')

    if submit_type
      form.ajaxSubmit
        dataType: 'json'
        success: (data) ->
          if data.success
            $('#message_message').val('')
            $.hide_post_form()
            $.hide_comment_form()
            if data.items
              $.each data.items, (i, item) ->
                console.log($(item.target))
                $.add_data(item.html, $(item.target), item.show_method)
            else
              if target
                $.add_data(data.html, $(target), show_method)
            if close
              $('.remodal-close').click()
              $('.token-input').tokenInput('clear')
          else
            if data.error
              $.show_message(data.error)
          if data.message
            $.show_message(data.message)
          _this.html(old_html).addClass('btn_form_js')
        error: (xhr, textStatus, errorThrown) ->
          $.gritter.add({
            title: " ",
            text: textStatus,
            image: '/assets/error.png'
          })
          _this.html(old_html).addClass('btn_form_js')
    else
      $.ajax
        url: url
        type: type
        data: data
        dataType: 'json'
        success: (data) ->
          $('#message_message').val('')
          if data.success
            $.hide_post_form()
            $.hide_comment_form()
            if data.items
              $.each data.items, (i, item) ->
                $.add_data(item.html, $(item.target), item.show_method)
            else
              if target
                $.add_data(data.html, $(target), show_method)
            if close
              $('.remodal-close').click()
              $('.token-input').tokenInput('clear')
          else
            if data.error
              $.show_message(data.error)
          if data.message
            $.show_message(data.message)
          _this.html(old_html).addClass('btn_form_js')
        error: (xhr, textStatus, errorThrown) ->
          $.gritter.add({ 
            title: " ",
            text: textStatus,
            image: '/assets/error.png'
          })
          _this.html(old_html).addClass('btn_form_js')

  $("#post-form").bind 'ajax:success', (xhr, data) ->
    responce = JSON.parse(data)
    if responce.success
      $('#message_message').val('')
  
  $(document).on 'keyup', '.autocomplete', ->
    _this = $(this)
    _this.addClass("load")
    clearTimeout $timeout
    $timeout = setTimeout(->  
      closest = _this.closest('.post-autocomplete-form')
      form = closest.find('form')
      url = $(".type.current").data('action') 
      type = form.attr('method')
      data = form.serialize()
      browser_url = url + data.slice(data.search("&search"), data.length)
      window.history.replaceState("", "", browser_url)
      target = _this.data('target')
      close = _this.data('close')
      show_method = _this.data('show-method')
      submit_type = form.attr('enctype')
      old_width = _this.width()
      old_height = _this.height()
      old_html = _this.html()
      $.ajax
        url: url
        type: type
        data: data
        dataType: 'json'
        success: (data) ->
          _this.removeClass("load")
          if data.success
            $.hide_post_form()
            $.hide_comment_form()
            if data.items
              $.each data.items, (i, item) ->
                $.add_data(item.html, $(item.target), item.show_method)
            else
              if target
                $.add_data(data.html, $(target), show_method)
            if close
              $('.remodal-close').click()
              $('.token-input').tokenInput('clear')
          else
            if data.error
              $.show_message(data.error)
          if data.message
            $.show_message(data.message)
          _this.html(old_html).addClass('autocomplete')
        error: _this.html(old_html).addClass('autocomplete')
    , 700)