module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    user.remember #generates the token, stores digest on db
    cookies.permanent.signed[:user_id] = user.id # permanently store and encrypt user id within cookie
    cookies.permanent.signed[:remember_token] = user.remember_token # permanently store and encrypt the remember token within cookie
  end

  def current_user
    # only hits the db once
    ## find_by method returns nil if id not found
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def logged_in?
    !current_user.nil?
  end

  def remember(user) ##pulls in user model, puts it in user var
    user.remember # remember method in the user model
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent.signed[:remember_token] = user.remember_token
  end
  # has only to do with the session part of the user
  # requires a forget method in model to handle the attribute
  def forget(user)
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

end
