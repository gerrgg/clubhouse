module UsersHelper

  def gravatar_for(user)
    image_tag gravatar_url(user.email)
  end

end
