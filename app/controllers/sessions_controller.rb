class SessionsController < ApplicationController
  skip_before_filter :authorize, :only => [:create, :new]

  def new
  end

  def create
    user = User.where(:uname => params[:name]).first
    if user && user.authenticate!(params[:password])
      session[:user_id] = user.id
      redirect_to admin_url
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    reset_session
    redirect_to store_url, notice: "You have successfully Logged out."
  end
end
