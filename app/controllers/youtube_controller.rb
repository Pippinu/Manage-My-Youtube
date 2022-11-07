require 'google/apis/youtube_v3'
require "google/api_client/client_secrets.rb"

require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'


class YoutubeController < ApplicationController
  # YOUTUBE_UPLOAD_SCOPE = 'https://www.googleapis.com/auth/youtube.upload'
  # YOUTUBE_API_SERVICE_NAME = 'youtube'
  # YOUTUBE_API_VERSION = 'v3'

  # SCOPE = ['https://www.googleapis.com/auth/calendar',
  #   'https://www.googleapis.com/auth/calendar.events',
  #   'https://www.googleapis.com/auth/calendar.events.readonly',
  #   'https://www.googleapis.com/auth/calendar.readonly',
  #   'https://www.googleapis.com/auth/calendar.settings.readonly',
  #   'https://www.googleapis.com/auth/youtube',
  #   'https://www.googleapis.com/auth/youtube.force-ssl',
  #   'https://www.googleapis.com/auth/youtube.readonly',
  #   'https://www.googleapis.com/auth/youtube.upload',
  #   'https://www.googleapis.com/auth/youtubepartner',
  #   'https://www.googleapis.com/auth/youtubepartner-channel-audit']

  # CLIENT_SECRETS_PATH = 'app/controllers/client_secret.json'
  # CREDENTIALS_PATH = "app/controllers/authCredentials.yaml"
  # REDIRECT_URI = 'http://localhost:3000/oauth2callback'
  # APPLICATION_NAME = 'Progetto LASSI'

  def list
    client = get_google_youtube_client current_user

    part = 'snippet,contentDetails,statistics'

    #@response = client.list_channels(part, "id": ["UC_x5XG1OV2P6uZZ5FSM9Ttw"]).to_json

    #METODO PER OTTENERE IL CANALE RELATIVO AL CLIENTE

    @mineresponse= client.list_channels(part, "mine":true).to_json
    item = JSON.parse(@mineresponse).fetch("items")[0]

    channelID= item.fetch("id")

    user = User.find(current_user.id)
    user.update_attribute(:channelID, channelID)

    @lisResp = "This channel's ID is #{item.fetch("id")}. " + "Its title is '#{item.fetch("snippet").fetch("title")}', and it has " + "#{item.fetch("statistics").fetch("viewCount")} views."
    #putes @listResp  
  rescue Google::Apis::AuthorizationError
    secrets = Google::APIClient::ClientSecrets.new({
        "web" => {
          "access_token" => current_user.access_token,
          "refresh_token" => current_user.refresh_token,
          "client_id" => ENV["GOOGLE_OAUTH_CLIENT_ID"],
          "client_secret" => ENV["GOOGLE_OAUTH_CLIENT_SECRET"]
        }
    })
    client.authorization = secrets.to_authorization
    client.authorization.grant_type = "refresh_token"

    client.authorization.refresh!
    current_user.update_attribute(:access_token, client.authorization.access_token)
    current_user.update_attribute(:refresh_token, client.authorization.refresh_token)
    retry
  end

  def list_subs

    if current_user.ruolo == "manager"
      cliente = User.find(params[:userID])
      client = get_google_youtube_client cliente
    else
      client = get_google_youtube_client current_user
    end

    @subsCount = client.list_channels(
      "snippet,contentDetails,statistics", 
      :mine => true
    )

    @subsList = client.list_subscriptions("subscriberSnippet", my_subscribers: true)

    @listActivities = client.list_activities("contentDetails", mine: true)

  rescue Google::Apis::AuthorizationError
    secrets = Google::APIClient::ClientSecrets.new({
        "web" => {
          "access_token" => current_user.access_token,
          "refresh_token" => current_user.refresh_token,
          "client_id" => ENV["GOOGLE_OAUTH_CLIENT_ID"],
          "client_secret" => ENV["GOOGLE_OAUTH_CLIENT_SECRET"]
        }
    })
    client.authorization = secrets.to_authorization
    client.authorization.grant_type = "refresh_token"

    client.authorization.refresh!
    current_user.update_attribute(:access_token, client.authorization.access_token)
    current_user.update_attribute(:refresh_token, client.authorization.refresh_token)
    retry
  end

  def list_activities

    client = get_google_youtube_client current_user

    maxResult = 50
    @listActivities = client.list_activities("snippet,contentDetails", mine: true, max_results: 100)
  rescue Google::Apis::AuthorizationError
    secrets = Google::APIClient::ClientSecrets.new({
        "web" => {
          "access_token" => current_user.access_token,
          "refresh_token" => current_user.refresh_token,
          "client_id" => ENV["GOOGLE_OAUTH_CLIENT_ID"],
          "client_secret" => ENV["GOOGLE_OAUTH_CLIENT_SECRET"]
        }
    })
    client.authorization = secrets.to_authorization
    client.authorization.grant_type = "refresh_token"

    client.authorization.refresh!
    current_user.update_attribute(:access_token, client.authorization.access_token)
    current_user.update_attribute(:refresh_token, client.authorization.refresh_token)

    retry
  end

  def list_vid

    client = get_google_youtube_client current_user
    
    maxResult = 50
    @listActivities = client.list_activities("snippet,contentDetails,id", mine: true, max_results: 100)

  rescue Google::Apis::AuthorizationError
    secrets = Google::APIClient::ClientSecrets.new({
        "web" => {
          "access_token" => current_user.access_token,
          "refresh_token" => current_user.refresh_token,
          "client_id" => ENV["GOOGLE_OAUTH_CLIENT_ID"],
          "client_secret" => ENV["GOOGLE_OAUTH_CLIENT_SECRET"]
        }
    })
    client.authorization = secrets.to_authorization
    client.authorization.grant_type = "refresh_token"

    client.authorization.refresh!
    current_user.update_attribute(:access_token, client.authorization.access_token)
    current_user.update_attribute(:refresh_token, client.authorization.refresh_token)
    retry
  end


  #   DA QUI
  def list_vid_con_channel_id     # usare questa per il manager che chiede video clienti
    #prendere per ogni user del manager l'id dal database

    client = get_google_youtube_client current_user

    channelID= params[:id]
    @listActivities = client.list_activities("snippet,contentDetails",channel_id: channelID, max_results: 10)

    puts @listActivities
  rescue Google::Apis::AuthorizationError
    secrets = Google::APIClient::ClientSecrets.new({
        "web" => {
          "access_token" => current_user.access_token,
          "refresh_token" => current_user.refresh_token,
          "client_id" => ENV["GOOGLE_OAUTH_CLIENT_ID"],
          "client_secret" => ENV["GOOGLE_OAUTH_CLIENT_SECRET"]
        }
    })
    client.authorization = secrets.to_authorization
    client.authorization.grant_type = "refresh_token"

    client.authorization.refresh!
    current_user.update_attribute(:access_token, client.authorization.access_token)
    current_user.update_attribute(:refresh_token, client.authorization.refresh_token)
    retry
  end

  #qui passare un array con i video risultato di list_vid_con_channel_id
  def video_stat

    client = get_google_youtube_client current_user

    @video_id= params[:id]
    maxResult = 50
    @videostat = client.list_videos("snippet,statistics,id",id: @video_id).items[0]
    puts @videostat

  rescue Google::Apis::AuthorizationError
    secrets = Google::APIClient::ClientSecrets.new({
        "web" => {
          "access_token" => current_user.access_token,
          "refresh_token" => current_user.refresh_token,
          "client_id" => ENV["GOOGLE_OAUTH_CLIENT_ID"],
          "client_secret" => ENV["GOOGLE_OAUTH_CLIENT_SECRET"]
        }
    })
    client.authorization = secrets.to_authorization
    client.authorization.grant_type = "refresh_token"

    client.authorization.refresh!
    current_user.update_attribute(:access_token, client.authorization.access_token)
    current_user.update_attribute(:refresh_token, client.authorization.refresh_token)
    retry
  end

  def insert_playlist
    client = get_google_youtube_client current_user
    # client = Google::Apis::YoutubeV3::YouTubeService.new
    # client.authorization = authorize

    playlistObj = Google::Apis::YoutubeV3::Playlist.new(
      snippet: {
        title: "Playlist di Prova",
        description: "Questa playlist è stata creata usando Youtube API"
      }
    )
    
    @playlist = client.insert_playlist("snippet", playlistObj)

  rescue Google::Apis::AuthorizationError
    secrets = Google::APIClient::ClientSecrets.new({
        "web" => {
          "access_token" => current_user.access_token,
          "refresh_token" => current_user.refresh_token,
          "client_id" => ENV["GOOGLE_OAUTH_CLIENT_ID"],
          "client_secret" => ENV["GOOGLE_OAUTH_CLIENT_SECRET"]
        }
    })
    client.authorization = secrets.to_authorization
    client.authorization.grant_type = "refresh_token"

    client.authorization.refresh!
    current_user.update_attribute(:access_token, client.authorization.access_token)
    current_user.update_attribute(:refresh_token, client.authorization.refresh_token)

    retry
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
