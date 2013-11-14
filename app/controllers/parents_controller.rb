class ParentsController < ApplicationController
  before_action :set_parent, only: [:show, :edit, :update, :destroy]

  def index
    @parents = Parent.all
  end

  def show
  end

  def new
    @parent = Parent.new
    @parent.kids.build
    @parent.deliveries.build
  end

  def edit
    @parent.kids.build
    @parent.deliveries.build
  end

  def create
    @parent = Parent.new(parent_params)

    respond_to do |format|
      if @parent.save
        format.html { redirect_to @parent, notice: 'Parent was successfully created.' }
        format.json { render action: 'show', status: :created, location: @parent }
      else
        format.html { render action: 'new' }
        format.json { render json: @parent.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @parent.update(parent_params)
        format.html { redirect_to @parent, notice: 'Parent was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @parent.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @parent.destroy
    respond_to do |format|
      format.html { redirect_to parents_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parent
      @parent = Parent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def parent_params
      params.require(:parent).permit(:name, :birthdate, :sex, :email, 
        kids_attributes: [:id, :type_setter, :name, :sex, :birthdate, :_destroy],
        deliveries_attributes: [:id, :type_setter, :email, :_destroy])
    end
end
