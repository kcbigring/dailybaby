class KidsController < ApplicationController
  before_action :set_kid, only: [:show, :edit, :update, :destroy]

  def index
    @kids = Kid.all
  end

  def show
  end

  def new
    @kid = Kid.new
    @kid.album = Album.new
  end

  def edit
    @kid.album = Album.new unless @kid.album
  end

  def create
    @kid = Kid.new(kid_params)

    respond_to do |format|
      if @kid.save
        format.html { redirect_to @kid, notice: 'Kid was successfully created.' }
        format.json { render action: 'show', status: :created, location: @kid }
      else
        format.html { render action: 'new' }
        format.json { render json: @kid.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @kid.update(kid_params)
        format.html { redirect_to @kid, notice: 'Kid was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @kid.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @kid.destroy
    respond_to do |format|
      format.html { redirect_to parents_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kid
      @kid = Kid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def kid_params
      params.require(:kid).permit(:name, :birthdate, :sex, :email, album_attributes: [:id, :smugmug_id, :custom_url, :password, :_destroy])
    end
end
