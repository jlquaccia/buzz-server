class LandingController < ApplicationController
  def callback
    @response = Instagram.get_access_token(params[:code], redirect_uri: ENV['REDIRECT_URI'])
    session[:access_token] = @response.access_token
    redirect_to root_path
  end

  def index
    @access_token = session[:access_token]

    # Get the list of users this user follows.
    ig_user_follows_response = HTTParty.get("https://api.instagram.com/v1/users/self/follows?access_token=#{@access_token}")
    @user_follows_hash_version = JSON.parse(ig_user_follows_response.body)

    # Get the most recent media published by a user.
    ig_user_recent_media_response = HTTParty.get("https://api.instagram.com/v1/users/26758193/media/recent/?access_token=#{@access_token}&count=30")
    @user_recent_media_hash_version = JSON.parse(ig_user_recent_media_response.body)
  end
end