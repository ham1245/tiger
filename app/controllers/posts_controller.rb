
class PostsController < ApplicationController


  def new
    @post = Post.new
  end

  def create

    @post = Post.new(post_params)
    @post.user_id = current_user.id #assign the post to the user who created it.

    #respond_to do |f|
     # if(@post.save)
        #f.html {redirect_to (:back), notice: "Post created!"}
      #else
       # f.html {redirect_to (:back), notice: "Error: Post Not Saved."}
      #end
    #end
     @homeURL = '/home'
     @exploreURL = '/explore'
    if session[:user_name] != nil
    @profileURL = '/user/' + session[:user_name]
    end

    #pages controller, home action
    if(session[:current_url] == @homeURL)
      @posts= Post.all
      @newPost = Post.new
    end
      #pages controller, explore action
    if (session[:current_url] == @exploreURL)
      @posts= Post.all
      @newPost = Post.new
      @toFollow = User.all.first(5)

    end
    #pages controller, profile action
    if (session[:current_url] == @profileURL)
      if (User.find_by_username(session[:user_name]))
        @username = session[:user_name]
      else
        redirect_to root_path, :notice =>"User not found"
      end

      @posts= Post.all.where("user_id= ?",User.find_by_username(session[:user_name]))

      @newPost = Post.new

      @toFollow = User.all.first(5)
    end


    respond_to do |f|
      if(@post.save)
        f.js {render 'pages/post.js.erb' }
      end
    end

  end

  private def post_params # allows certain data to be passed via form.
            params.require(:post).permit(:user_id, :content)
  end
end