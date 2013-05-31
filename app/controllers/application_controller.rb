class ApplicationController < ActionController::Base

  before_filter :authorize
  protect_from_forgery
  protected
    def authorize
      unless User.where(:id => session[:user_id]).first
        redirect_to login_url, notice: "Please log in"
      end
    end

  private
  
    def current_cart
      session[:counter] = 0
      cart = Cart.where(:id => session[:cart_id]).first_or_create
      session[:cart_id] ||= cart.id
      cart
    end
end
