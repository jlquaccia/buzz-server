class LandingController < ApplicationController
  def callback
    @response = Instagram.get_access_token(params[:code], redirect_uri: ENV['REDIRECT_URI'])
    session[:access_token] = @response.access_token
    redirect_to root_path
  end

  def index
    @access_token = session[:access_token]
    @hash_version_array = []

    # Get the list of users this user follows.
    ig_user_follows_response = HTTParty.get("https://api.instagram.com/v1/users/self/follows?access_token=#{@access_token}")
    @user_follows_hash_version = JSON.parse(ig_user_follows_response.body)

    # Get the most recent media published by myself.
    ig_user_self_recent_media_response = HTTParty.get("https://api.instagram.com/v1/users/self/media/recent/?access_token=#{@access_token}&count=30")
    @user_self_recent_media_hash_version = JSON.parse(ig_user_self_recent_media_response.body)

    # Get the most recent media published by another user.
    @user_follows_hash_version['data'].each do |item|
      user_id = item['id']
      ig_user_recent_media_response = HTTParty.get("https://api.instagram.com/v1/users/#{user_id}/media/recent/?access_token=#{@access_token}&count=50")
      @user_recent_media_hash_version = JSON.parse(ig_user_recent_media_response.body)
      @hash_version_array << @user_recent_media_hash_version if @user_recent_media_hash_version != []
    end
  end
end