class PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :dislike]
    before_action :authorize_user!, only: %i[edit update destroy show]
    
    # GET /posts
    def index
       if user_signed_in?
        # Show public posts + private posts owned by the current user
        @posts = Post.where("visibility = ? OR user_id = ?", 'public', current_user.id)
      # elsif user_signed_in?
      #   # Show public posts + private posts owned by the current user
      #   @posts = Post.where("visibility = ? OR user_id = ?", 'public', current_user.id)
      else
        # Show only public posts
        @posts = Post.public_posts
      
    end
  end
    
    # GET /posts/:id
    def show
      if @post.visibility == 'private' && @post.user != current_user
        redirect_to posts_path, alert: 'You are not authorized to view this post.'
      end
  end


    
    # GET /posts/new
    def new
      @post = current_user.posts.build
    end
    
    # POST /posts
    def create
      @post = current_user.posts.build(post_params)
      if @post.save
        redirect_to @post, notice: 'Post was successfully created.'
      else
        render :new
      end
    end
    
    # GET /posts/:id/edit
    def edit
    end

    def like
      @post.liked_by current_user
      redirect_to @post
    end
  
    def dislike
      @post.disliked_by current_user
      redirect_to @post
    end
    
    
    # PATCH/PUT /posts/:id
    def update
      if @post.update(post_params)
        redirect_to @post, notice: 'Post was successfully updated.'
      else
        render :edit
      end
    end
    
    # DELETE /posts/:id
    def destroy
      @post.destroy
      redirect_to posts_url, notice: 'Post was successfully destroyed.'
    end
    
    private
    
    def set_post
      @post = Post.find(params[:id])
    end

    def authorize_user!
      redirect_to posts_path, alert: 'Not authorized!' unless @post.user == current_user
    end

  
    
    def post_params
      params.require(:post).permit(:title, :content, :visibility)
    end
  end
  