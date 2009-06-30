module UsersHelper
  # Link to a user (default is by name).
  # TODO: refactor this thing.
  def user_link(text, user = nil, html_options = nil)
    if user.nil?
      user = text
      text = user.name
    elsif user.is_a?(Hash)
      html_options = user
      user = text
      text = user.name
    end
    # We normally write link_to(..., user) for brevity, but that breaks
    # activities_helper_spec due to an RSpec bug.
    link_to(h(text), user, html_options)
  end

  def short_time(time)
    time.strftime('%y-%m-%d %H:%M')
  end

  #显示用户刚说了链接(类似link_to_unless_current)
  def answers_link
    text = "#{@user.login}刚说了......"
    if action_name == 'show'
      return text
    end
    link_to "#{@user.login}刚说了......", @user
  end
  
  #显示用户刚问了
  def questions_link
    text = "#{@user.login}刚问了......"
    if action_name == 'questions'
      return text
    end
    link_to "#{@user.login}刚问了......", user_question_path(@user)
  end
end
