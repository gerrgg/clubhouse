class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated && user.authenticated?('activation', params[:id])
      user.activate
      log_in user
      flash[:success] = "Hello #{user.name}"
      redirect_to user
    else
      flash[:warning] = "Activation invalid"
      redirect_to root_url
    end
  end

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user
      user.create_activation_digest
      user.send_activation_email
      flash[:success] = "Your email should be there soon."
    else
      flash[:warning] = "Email is either already active or is invalid."
    end
    redirect_to login_path
  end
end
