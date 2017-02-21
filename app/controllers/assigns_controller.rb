class AssignsController < ApplicationController
  before_action :set_assign, only: [:show, :edit, :update, :destroy]

  # GET /assigns
  # GET /assigns.json
  def index
    @assigns = Assign.all
  end

  # GET /assigns/1
  # GET /assigns/1.json
  def show
  end

  # GET /assigns/new
  def new
    @assign = Assign.new
    @receive_id = params[:receive]
    @receive_line = ReceiveLine.where("receive_id = ? AND qty > 0",@receive_id)
    @consolidate_by = Array.new(@receive_line.length)
    @cons_dept = Array.new(@receive_line.length)
    @cons_desig = Array.new(@receive_line.length)
  end

  # GET /assigns/1/edit
  def edit
  end

  # POST /assigns
  # POST /assigns.json
  def create
    @assign = Assign.new(assign_params)
    @receive_id = params[:receive]
    @receive_line = ReceiveLine.where("receive_id = ? AND qty > 0",@receive_id)
    @consolidate_by = Array.new(@receive_line.length)
    @cons_dept = Array.new(@receive_line.length)
    @cons_desig = Array.new(@receive_line.length)

    # raise params.inspect
    if @assign.save

      flash[:success] = "Purchase Order has successfully Received. Received Equipments are now in the inventory."
      redirect_to assigns_path
    else
      render 'new'
    end
  end

  # PATCH/PUT /assigns/1
  # PATCH/PUT /assigns/1.json
  def update
    respond_to do |format|
      if @assign.update(assign_params)
        format.html { redirect_to @assign, notice: 'Assign was successfully updated.' }
        format.json { render :show, status: :ok, location: @assign }
      else
        format.html { render :edit }
        format.json { render json: @assign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assigns/1
  # DELETE /assigns/1.json
  def destroy
    @assign.destroy
    respond_to do |format|
      format.html { redirect_to assigns_url, notice: 'Assign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assign
      @assign = Assign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assign_params
      params.require(:assign).permit(:user_id, :remarks,
        assign_lines_attributes: [:assign_id, :user_id, :inventory_id, :inventory_number])
    end
end
