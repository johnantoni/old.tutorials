class BlogController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @posts = Post.find(:all)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      flash[:notice] = 'Post was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post was successfully updated.'
      redirect_to :action => 'show', :id => @post
    else
      render :action => 'edit'
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def comment
    Post.find(params[:id]).comments.create(params[:comment])
    flash[:notice] = "added your comment."
    redirect_to :action => "show", :id => params[:id] 
  end
    
end
