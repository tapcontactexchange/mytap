class ZapcardsController < ApplicationController
  # GET /zapcards
  # GET /zapcards.json
  def index
    @zapcards = Zapcard.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @zapcards }
    end
  end

  # GET /zapcards/1
  # GET /zapcards/1.json
  def show
    @zapcard = Zapcard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @zapcard }
    end
  end

  # GET /zapcards/new
  # GET /zapcards/new.json
  def new
    @zapcard = Zapcard.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @zapcard }
    end
  end

  # GET /zapcards/1/edit
  def edit
    @zapcard = Zapcard.find(params[:id])
  end

  # POST /zapcards
  # POST /zapcards.json
  def create
    @zapcard = Zapcard.new(params[:zapcard])

    respond_to do |format|
      if @zapcard.save
        format.html { redirect_to @zapcard, notice: 'Zapcard was successfully created.' }
        format.json { render json: @zapcard, status: :created, location: @zapcard }
      else
        format.html { render action: "new" }
        format.json { render json: @zapcard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /zapcards/1
  # PUT /zapcards/1.json
  def update
    @zapcard = Zapcard.find(params[:id])

    respond_to do |format|
      if @zapcard.update_attributes(params[:zapcard])
        format.html { redirect_to @zapcard, notice: 'Zapcard was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @zapcard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zapcards/1
  # DELETE /zapcards/1.json
  def destroy
    @zapcard = Zapcard.find(params[:id])
    @zapcard.destroy

    respond_to do |format|
      format.html { redirect_to zapcards_url }
      format.json { head :no_content }
    end
  end
end
