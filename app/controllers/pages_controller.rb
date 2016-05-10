class PagesController < ApplicationController
  def index

  end



  def home
    session[:current_url] = '/home'
    @posts= Post.all
    @newPost = Post.new
  end

  def profile

    if (User.find_by_username(params[:id]))
    @username = params[:id]
    session[:current_url] = '/user/' + params[:id]
    session[:user_name] = params[:id]
    else
      redirect_to root_path, :notice =>"User not found"
    end

    @posts= Post.all.where("user_id= ?",User.find_by_username(params[:id]))

    @newPost = Post.new

    @toFollow = User.all.first(5)
  end

  def explore
    session[:current_url] = '/explore'
    @posts= Post.all
    @newPost = Post.new
    @toFollow = User.all.first(5)
  end

  def like
    currentPost = Post.find(params[:id])
    likesNum = 0
    if currentPost.likes == nil
      likesNum = 1
    else
      likesNum = (currentPost.likes + 1)
    end
    currentPost.update(likes:likesNum)
    redirect_to (:back)
  end

  def retweet
    content = Post.find(params[:repost]).content
    @post = Post.new
    @post.content = content
    @post.user_id = current_user.id #assign the post to the user who created it.
    respond_to do |f|
      if(@post.save)
        f.html {redirect_to (:back), notice: "Retweeted!"}
      else
        f.html {redirect_to (:back), notice: "Error: Post Not Saved."}
      end
    end
  end

  def destroy
    @post = Post.find(params[:depost])
    @post.destroy
    redirect_to (:back)
  end

  def following
    if (User.find_by_username(params[:id]))
      @username= params[:id]
    else
      redirect_to root_path, :notice =>"User not found"
    end

    @toFollow = User.all.first(5)
  end

  def followers
    if (User.find_by_username(params[:id]))
      @username= params[:id]
    else
      redirect_to root_path, :notice =>"User not found"
    end

    @toFollow = User.all.first(5)
  end


end
