class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    sleep 1
    @orders = Order.all.order("created_at DESC").paginate(page: params[:page], per_page: 5)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  # inputChangeSelector
  def new
    @time = Time.now 
    @order = Order.new
    @cons_ids = params[:cons_ids]
    @consolidate_lines = ConsolidateLine.where(:consolidate_id => @cons_ids)
    @order_last = Order.last()
    if @order_last == nil
      @ponum = "4900000001"
    else
      @ponum = @order_last.PONumber.to_i + 1
    end
    sleep 1
  end

  # GET /orders/1/edit
  def edit
    sleep 1
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @time = Time.now 
    @order_last = Order.last()
    if @order_last == nil
      @ponum = "4900000001"
    else
      @ponum = @order_last.PONumber.to_i + 1
    end
    arr = Array.new(params[:order][:order_lines_attributes].length)
    i = 0
    while i < params[:order][:order_lines_attributes].length do
      arr[i] = params[:order][:order_lines_attributes]["#{i}"][:consolidate_id]
      i +=1
    end
    @consolidate = Consolidate.find(arr)
    # raise params.inspect
    if @order.save
      @consolidate.each do |cons|
        params = ActionController::Parameters.new({
          request: {
            status: "Purchase Ordered"
          }
        })
        permitted = params.require(:request).permit(:status)
        cons.update(permitted)
      end
      flash[:success] = "Purchase Order has successfully generated"
      redirect_to orders_path
    else
      render 'new'
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update 
    params = ActionController::Parameters.new({
        order: {
          total_amount: order_params[:total_amount]
        }
      })
    permitted = params.require(:order).permit(:total_amount) 
    if @order.update(permitted)
      i = 0  
      while i < order_params[:order_lines_attributes].length
        params = ActionController::Parameters.new({
          order_line: {
            unit_price: order_params[:order_lines_attributes]["#{i}"][:unit_price], 
            amount: order_params[:order_lines_attributes]["#{i}"][:amount]
          }
        })
        asd = params.require(:order_line).permit(:unit_price, :amount) 
        @order_line = OrderLine.find(@order.order_lines.ids[i])
        @order_line.update(asd)
        i +=1
        end  
      flash[:success] = "Purchase Order has successfully updated"
      redirect_to orders_path
    else
      render 'edit'
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:PONumber, :terms, :delivery_date, :supplier_id, :total_amount, :user_id, :status,
        order_lines_attributes: [:consolidate_id, :type_id, :product_id, :description, :qty, :unit_id, :unit_price, :amount])
    end
end
