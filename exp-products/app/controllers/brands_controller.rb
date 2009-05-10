class BrandsController < ApplicationController
  before_filter :load_client
  # GET /brands
  # GET /brands.xml
  def index
    @brands = @client.brands

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @brands }
    end
  end

  # GET /brands/1
  # GET /brands/1.xml
  def show
    @brand = @client.brands.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @brand }
    end
  end

  # GET /brands/new
  # GET /brands/new.xml
  def new
    @brand = @client.brands.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @brand }
    end
  end

  # GET /brands/1/edit
  def edit
    @brand = @client.brands.find(params[:id])
  end

  # POST /brands
  # POST /brands.xml
  def create
    @brand = @client.brands.build(params[:brand])

    respond_to do |format|
      if @brand.save
        flash[:notice] = 'Brand was successfully created.'
        format.html { redirect_to([@client, @brand]) }
        format.xml  { render :xml => @brand, :status => :created, :location => @brand }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @brand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /brands/1
  # PUT /brands/1.xml
  def update
    @brand = @client.brands.find(params[:id])

    respond_to do |format|
      if @brand.update_attributes(params[:brand])
        flash[:notice] = 'Brand was successfully updated.'
        format.html { redirect_to([@client, @brand]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @brand.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.xml
  def destroy
    @brand = @client.brands.find(params[:id])
    @brand.destroy

    respond_to do |format|
      format.html { redirect_to(brands_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    def load_client
      @client = Client.find(params[:client_id])
    end
end
