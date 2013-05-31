class AdminController < ApplicationController
  def index
    @orders = Order.paginate(:page => params[:page],
                             :per_page => 10,
                             :order => 'created_at desc')
  end
end
