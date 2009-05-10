class ProductsController < ApplicationController
  before_filter :load_client
  before_filter :load_brand
  
  # GET /products
  # GET /products.xml
  def index
    @products = @brand.products.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = @brand.products.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = @brand.products.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = @brand.products.find(params[:id])
  end

  # POST /products
  # POST /products.xml
  def create
    @product = @brand.products.build(params[:product])

    respond_to do |format|
      if @product.save
        flash[:notice] = 'Product was successfully created.'
        format.html { redirect_to([@client, @brand, @product]) }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = @brand.products.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        flash[:notice] = 'Product was successfully updated.'
        format.html { redirect_to([@client, @brand, @product]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = @brand.products.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(client_brand_products_url(@client, @brand)) }
      format.xml  { head :ok }
    end
  end
  
  private
    def load_client
      @client = Client.find(params[:client_id])
    end
    
    def load_brand
      @brand = @client.brands.find(params[:brand_id])
    end
end
