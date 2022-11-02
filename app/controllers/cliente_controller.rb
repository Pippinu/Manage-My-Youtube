require 'google/apis/youtube_v3'
require "google/api_client/client_secrets.rb"

class ClienteController < ApplicationController

    before_action:require_user_logged_in!
    before_action:are_you_a_client

    YOUTUBE_UPLOAD_SCOPE = 'https://www.googleapis.com/auth/youtube.upload'
    YOUTUBE_API_SERVICE_NAME = 'youtube'
    YOUTUBE_API_VERSION = 'v3'

    def search
        @users = User.all
    end

    def function
        client = get_google_youtube_client current_user

        part = 'snippet,contentDetails,statistics'

        @mineresponse= client.list_channels(part, "mine":true).to_json
    end

    def visualize
        @profilatoId= params[:id]
        @profilato = User.find(params[:id])
        is_it_a_manager(@profilato)
    end

    def events
        @events=Event.all
    end

    def get_google_youtube_client current_user
        client = Google::Apis::YoutubeV3::YouTubeService.new
    
        return unless (current_user.present? && current_user.access_token.present? && current_user.refresh_token.present?)
        secrets = Google::APIClient::ClientSecrets.new({
          "web" => {
            "access_token" => current_user.access_token,
            "refresh_token" => current_user.refresh_token,
            "client_id" => ENV["GOOGLE_OAUTH_CLIENT_ID"],
            "client_secret" => ENV["GOOGLE_OAUTH_CLIENT_SECRET"]
          }
        })
        begin
          client.authorization = secrets.to_authorization
          client.authorization.grant_type = "refresh_token"
    
          if !current_user.present?
            client.authorization.refresh!
            current_user.update_attributes(
              access_token: client.authorization.access_token,
              refresh_token: client.authorization.refresh_token
            )
          end
        rescue => e
          flash[:error] = 'Your token has been expired. Please login again with google.'
          redirect_to :back
        end
        client
      end
      
end