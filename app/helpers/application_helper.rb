module ApplicationHelper

  def stub_path
    "javascript:void(0);"
  end

  def user_status(user, mini=false)
    if user.online? || user == current_user || user.show_status == false
      "<p class='green'>Online</p>"
    else
      if mini
        "<p class='red'>Offline</p>"
      else
        "<p class='red'>Offline</p>" + "<p class='time'>#{user.status}</p>"
      end
    end.html_safe
  end

end
