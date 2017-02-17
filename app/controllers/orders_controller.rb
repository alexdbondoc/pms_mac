class OrdersController < ApplicationController
  before_action :require_user
  before_action :require_property
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    sleep 1
    @orders = Order.order("created_at DESC").paginate(page: params[:page], per_page: 5)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  # inputChangeSelector
  def new
    sleep 1
    @time = Time.now 
    @order = Order.new
    @cons_ids = params[:cons_ids]
    @consolidate_lines = ConsolidateLine.where(:consolidate_id => @cons_ids)
    @order_last = Order.last()
    @supp = Supplier.all
    i = 0
    @supp_add = Array.new(@supp.length)
    @supp.each do |supp| 
      @supp_add[i] = supp.address
      i +=1
    end
    if @order_last == nil
      @ponum = "4900000001"
    else
      @ponum = @order_last.PONumber.to_i + 1
    end
  end

  # GET /orders/1/edit
  def edit
    sleep 1
    @supp = Supplier.all
    i = 0
    @supp_add = Array.new(@supp.length)
    @supp.each do |supp| 
      @supp_add[i] = supp.address
      i +=1
    end
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
    @supp = Supplier.all
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
    @action = params[:commit]
    ords_ids = params[:ords_ids]
    @receive = params[:receive]
    @reject = params[:reject]
    if @receive != nil
      if @order.status == "Pending"
        redirect_to new_receife_path(:order => @order)
      else
        @receive = Receive.where("order_id" => @order)
        @receive.each do |r|
          @id = r.id
        end
        # raise params.inspect
        redirect_to edit_receife_path(:id => @id)
      end
    elsif @action == "Reject" || @reject != nil
      if @reject != nil
        params = ActionController::Parameters.new({
          order: {
            status: "Rejected"
          }
        })
        permitted = params.require(:order).permit(:status) 
        if @order.update(permitted)
        else
          flash[:warning] = "Purchase Order has successfully rejected"
          redirect_to orders_path
        end
      else
        x = 0
        arr = ords_ids.tr('', '').split(',').map(&:to_i)
        status = Array.new(arr.length)
        @orders = Order.find(arr)
        @orders.each do |o|
          status[x] = o.status
          x +=1
        end
        if status.include?("Rejected") || status.include?("Received")
          flash[:danger] = "Unable to reject purchase order. Please select a pending one."
          redirect_to orders_path
        elsif status.uniq.length == 0
          flash[:danger] = "Please select purchase order to reject."
          redirect_to orders_path
        else
          @orders.each do |o|
            params = ActionController::Parameters.new({
              order: {
                status: "Rejected"
              }
            })
            permitted = params.require(:order).permit(:status) 
            o.update(permitted)
          end
          flash[:success] = "Purchase Order has successfully rejected."
          redirect_to orders_path
        end
        # raise params.inspect
      end
    else
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
