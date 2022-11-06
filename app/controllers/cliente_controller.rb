require 'google/apis/youtube_v3'
require "google/api_client/client_secrets.rb"

require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

class ClienteController < ApplicationController

  SCOPE = ['https://www.googleapis.com/auth/calendar',
    'https://www.googleapis.com/auth/calendar.events',
    'https://www.googleapis.com/auth/calendar.events.readonly',
    'https://www.googleapis.com/auth/calendar.readonly',
    'https://www.googleapis.com/auth/calendar.settings.readonly',
    'https://www.googleapis.com/auth/youtube',
    'https://www.googleapis.com/auth/youtube.force-ssl',
    'https://www.googleapis.com/auth/youtube.readonly',
    'https://www.googleapis.com/auth/youtube.upload',
    'https://www.googleapis.com/auth/youtubepartner',
    'https://www.googleapis.com/auth/youtubepartner-channel-audit']

  CLIENT_SECRETS_PATH = 'app/controllers/client_secret.json'
  CREDENTIALS_PATH = "app/controllers/authCredentials.yaml"
  REDIRECT_URI = 'http://localhost:3000/oauth2callback'
  APPLICATION_NAME = 'Progetto LASSI'

    before_action:require_user_logged_in!
    before_action:are_you_a_client

    YOUTUBE_UPLOAD_SCOPE = 'https://www.googleapis.com/auth/youtube.upload'
    YOUTUBE_API_SERVICE_NAME = 'youtube'
    YOUTUBE_API_VERSION = 'v3'

    def search
        @users = User.all
    end

    def function
      #client = Google::Apis::YoutubeV3::YouTubeService.new
      #client.authorization = authorize

      client = get_google_youtube_client current_user
      
      part = 'snippet,contentDetails,statistics'

      @mineresponse= client.list_channels(part, "mine":true).to_json
      item = JSON.parse(@mineresponse).fetch("items")[0]

      channelID= item.fetch("id")

      user = User.find(current_user.id)
      user.update_attribute(:channelID, channelID)
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

    def authorize
      FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))
    
      client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(
        client_id, SCOPE, token_store)
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      if credentials.nil?
        url = authorizer.get_authorization_url(base_url: REDIRECT_URI)
        puts "Open the following URL in the browser and enter the " +
              "resulting code after authorization"
        puts url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: REDIRECT_URI)
      end
      credentials
    end
      
end