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
end