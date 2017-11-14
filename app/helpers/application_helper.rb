module ApplicationHelper

  def full_title(page_title = "")
    base_title = "The Clubhouse"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def gravatar_url(email, size = '64')
    gravatar = Digest::MD5::hexdigest(email).downcase
    url = "http://gravatar.com/avatar/#{gravatar}.png?s=#{size}"
  end

end
