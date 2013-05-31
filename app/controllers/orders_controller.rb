class OrdersController < ApplicationController
  skip_before_filter :authorize, only: [:new, :create]
  before_filter :check_credit_card_number, :only => [:create]
  before_filter :load_gateway, :only => [:create]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.paginate page: params[:page], order: 'name,email,address',
      per_page: 20

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Your cart is empty"
      return
    end
    @order = Order.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  # def edit
  #   @order = Order.find(params[:id])
  # end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order]) do |order|
      order.total_amount = (current_cart.total_price/1000)
    end
    respond_to do |format|
      if (purchase = @gateway.purchase(@order.total_amount, @credit_card)).success?
        @order.add_line_items_from_cart(current_cart)
        if @order.save
          Cart.where(:id => session[:cart_id]).destroy
          session[:cart_id] = nil
          OrderNotifier.delay.received(@order)
          format.html { redirect_to store_url, notice: 'Thank You for Placing Order' }
          format.json { render json: @order, status: :created, location: @order }
        else
          @cart = current_cart
          format.html { render action: "new" }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      else
        Rails.logger.info purchase
        @cart = current_cart
        format.html { render action: "new" }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  # def update
  #   @order = Order.find(params[:id])

  #   respond_to do |format|
  #     if @order.update_attributes(params[:order])
  #       format.html { redirect_to @order, notice: 'Order was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @order.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private
    def check_credit_card_number
      options = params.delete(:date).merge(
                {
                  :number             => params[:card_number],
                  :first_name         => params[:order][:first_name],
                  :last_name          => params[:order][:last_name],
                  :verification_value => (params[:cvv] ||'000'),
                })
      @credit_card = ActiveMerchant::Billing::CreditCard.new( options )
      unless @credit_card.valid?
        @cart = current_cart
        @order = Order.new(params[:order])
        flash[:errors] = 'credit card details are not correct'
        (render 'new') && return
      end
    end

    def load_gateway
      config = YAML.load(File.open("#{Rails.root}/config/braintree.yml"))[Rails.env].symbolize_keys
      @gateway = ActiveMerchant::Billing::BraintreeGateway.new(config)
    end
end
