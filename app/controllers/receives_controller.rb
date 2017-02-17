class ReceivesController < ApplicationController
  before_action :require_user
  before_action :require_property
  before_action :set_receive, only: [:show, :edit, :update, :destroy]

  # GET /receives
  # GET /receives.json
  def index
    sleep 1
    @receives = Receive.order("created_at DESC").paginate(page: params[:page], per_page: 5)
  end

  # GET /receives/1
  # GET /receives/1.json
  def show
  end

  # GET /receives/new
  def new
    sleep 1
    @time = Time.now
    @receive = Receive.new
    @receive_last = Receive.last()
    @order_id = params[:order]
    @order = Order.find(@order_id)
    @order_lines = OrderLine.where(:order_id => @order_id)
    if @receive_last == nil
      @receive_num = "5000000001"
    else
      @receive_num = @receive_last.receive_num.to_i + 1
    end
    # raise params.inspect
  end

  # GET /receives/1/edit
  def edit
    @time = Time.now
    @order_lines = OrderLine.where(:order_id => @receive.order_id)
    @lines = Array.new(@order_lines.length)
    i = 0
    @order_lines.each do |ol|
      @lines[i] = ol
      i +=1
    end
    # raise params.inspect
  end

  # POST /receives
  # POST /receives.json
  def create
    @receive = Receive.new(receive_params)
    @time = Time.now
    @receive_last = Receive.last()
    @order_id = params[:order]
    @order = Order.find(@order_id)
    @order_lines = OrderLine.where(:order_id => @order_id)
    if @receive_last == nil
      @receive_num = "5000000001"
    else
      @receive_num = @receive_last.receive_num.to_i + 1
    end
    arr = Array.new(params[:remain_qty].length)
    i = 0
    if params[:types] == "Partial Delivery"
      type = "Partially Received"
    else
      type = "Completely Received"
    end
    params[:remain_qty].each do |k, v|
      arr[i] = v
      i +=1
    end
    if @receive.save
      i = 0
      @order_lines.each do |lines|
        params = ActionController::Parameters.new({
            order_line: {
              qty: arr[i]
            }
          })
          asd = params.require(:order_line).permit(:qty) 
          @order_line = OrderLine.find(lines.id)
          @order_line.update(asd)
          i +=1
      end
      params = ActionController::Parameters.new({
        order: {
          status: type
        }
      })
      zxc = params.require(:order).permit(:status) 
      @order.update(zxc)
      flash[:success] = "Purchase Order has successfully Received."
      redirect_to receives_path
    else
      render 'new'
    end
  end

  # PATCH/PUT /receives/1
  # PATCH/PUT /receives/1.json
  def update
    @time = Time.now
    @order = Order.find(@receive.order_id)
    @order_lines = OrderLine.where(:order_id => @receive.order_id)
    @lines = Array.new(@order_lines.length)
    i = 0
    @order_lines.each do |ol|
      @lines[i] = ol
      i +=1
    end
    arr = Array.new(params[:remain_qty].length)
    qty_arr = Array.new(params[:remain_qty].length)
    i = 0
    x = 0
    if params[:types] == "Partial Delivery"
      type = "Partially Received"
    else
      type = "Completely Received"
    end
    params[:remain_qty].each do |k, v|
      arr[i] = v
      i +=1
    end

    j = 0 

    while j < arr.length
      receive_params[:receive_lines_attributes]["#{j}"][:receiving_qty] = receive_params[:receive_lines_attributes]["#{j}"][:receiving_qty].to_i + @receive.receive_lines[j].receiving_qty.to_i
      j +=1
    end

    if @receive.update(receive_params)
      i = 0
      @order_lines.each do |lines|
        params = ActionController::Parameters.new({
            order_line: {
              qty: arr[i]
            }
          })
          asd = params.require(:order_line).permit(:qty) 
          @order_line = OrderLine.find(lines.id)
          @order_line.update(asd)
          i +=1
      end
      params = ActionController::Parameters.new({
        order: {
          status: type
        }
      })
      zxc = params.require(:order).permit(:status) 
      @order.update(zxc)
      flash[:success] = "Purchase Order has successfully Received."
      redirect_to receives_path
    else
      render 'edit'
    end
  end

  # DELETE /receives/1
  # DELETE /receives/1.json
  def destroy
    @receive.destroy
    respond_to do |format|
      format.html { redirect_to receives_url, notice: 'Receive was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receive
      @receive = Receive.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def receive_params
      params.require(:receive).permit(:receive_num, :user_id, :dr_num, :dr_date, :invoice_num, :invoice_date, :delivery_type, :order_id, :gross, :tax, :net,  
        receive_lines_attributes: [:receive_id, :type_id, :product_id, :description, :qty, :unit_id, :receiving_qty])
    end
end