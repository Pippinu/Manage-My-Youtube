require 'google/apis/youtube_v3'
require "google/api_client/client_secrets.rb"

require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'


class YoutubeController < ApplicationController
  # YOUTUBE_UPLOAD_SCOPE = 'https://www.googleapis.com/auth/youtube.upload'
  # YOUTUBE_API_SERVICE_NAME = 'youtube'
  # YOUTUBE_API_VERSION = 'v3'

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

  def list
    client = get_google_youtube_client current_user

    part = 'snippet,contentDetails,statistics'

    #METODO PER OTTENERE IL CANALE RELATIVO AL CLIENTE

    @mineresponse= client.list_channels(part, "mine":true).to_json

    @response = client.list_channels(part, "id": ["UC_x5XG1OV2P6uZZ5FSM9Ttw"]).to_json

    item = JSON.parse(@response).fetch("items")[0]

    @lisResp = "This channel's ID is #{item.fetch("id")}. " + "Its title is '#{item.fetch("snippet").fetch("title")}', and it has " + "#{item.fetch("statistics").fetch("viewCount")} views."
      
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
    # client = get_google_youtube_client current_user
    # youtube = Google::Apis::YoutubeV3::YouTubeService.new
    # youtube.authorization = authorize

    if current_user.ruolo === "manager"
      cliente = User.find(params[:userID])
      youtube = get_google_youtube_client cliente
    else
      youtube = get_google_youtube_client current_user
    end

    @subsCount = youtube.list_channels(
      "snippet,contentDetails,statistics", 
      :mine => true
    )

    @subsList = youtube.list_subscriptions("subscriberSnippet", my_subscribers: true)

    @listActivities = youtube.list_activities("contentDetails", mine: true)

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
    # client = get_google_youtube_client current_user
    client = Google::Apis::YoutubeV3::YouTubeService.new
    client.authorization = authorize
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

  def insert_playlist
    # client = get_google_youtube_client current_user
    client = Google::Apis::YoutubeV3::YouTubeService.new
    client.authorization = authorize

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
  # def youtubeListProva
  #   client = get_google_youtube_client current_user
  #   @dati = client.list_channels("UCJgEAT_2X9rkjjyq5cfZ-GQ")
      
  # rescue Google::Apis::AuthorizationError
  #     secrets = Google::APIClient::ClientSecrets.new({
  #         "web" => {
  #           "access_token" => current_user.access_token,
  #           "refresh_token" => current_user.refresh_token,
  #           "client_id" => ENV["GOOGLE_OAUTH_CLIENT_ID"],
  #           "client_secret" => ENV["GOOGLE_OAUTH_CLIENT_SECRET"]
  #         }
  #     })
  #     client.authorization = secrets.to_authorization
  #     client.authorization.grant_type = "refresh_token"

  #     client.authorization.refresh!
  #     current_user.update_attribute(:access_token, client.authorization.access_token)
  #     current_user.update_attribute(:refresh_token, client.authorization.refresh_token)
      
  #     retry
  # end

  # def uploadProva
  #   client = get_google_youtube_client current_user
  #   youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

  #   respond_to do |format|
  #     format.html { render :upload_video }
  #   end
  #   required = [:name, :email, :reply, :feedback_type, :message]
  #   form_complete = true
  #   required.each do |f|
  #     if params.has_key? f and not params[f].blank?
  #       # that's good news. do nothing
  #     else
  #       form_complete = false
  #     end
  #   end
  #   if form_complete
  #     form_status_msg = 'Thank you for your feedback!'
  #   else
  #     form_status_msg = 'Please fill in all the remaining form fields and resubmit.'
  #   end
  #   format.html { render :contact, locals: { status_msg: form_status_msg } }

  #   begin
  #     body = {
  #       :snippet => {
  #         :title => opts[:title],
  #         :description => opts[:description],
  #         :tags => opts[:keywords].split(','),
  #         :categoryId => opts[:category_id],
  #       },
  #       :status => {
  #         :privacyStatus => opts[:privacy_status]
  #       }
  #     }
  
  #     videos_insert_response = client.execute!(
  #       :api_method => youtube.videos.insert,
  #       :body_object => body,
  #       :media => Google::APIClient::UploadIO.new(opts[:file], 'video/*'),
  #       :parameters => {
  #         :uploadType => 'resumable',
  #         :part => body.keys.join(',')
  #       }
  #     )
  
  #     videos_insert_response.resumable_upload.send_all(client)
  
  #     @inserted = "Video id '#{videos_insert_response.data.id}' was successfully uploaded."
  #   rescue Google::APIClient::TransmissionError => e
  #     @resBody = e.result.body
  #   end
      
  # rescue Google::Apis::AuthorizationError
  #     secrets = Google::APIClient::ClientSecrets.new({
  #         "web" => {
  #           "access_token" => current_user.access_token,
  #           "refresh_token" => current_user.refresh_token,
  #           "client_id" => ENV["GOOGLE_OAUTH_CLIENT_ID"],
  #           "client_secret" => ENV["GOOGLE_OAUTH_CLIENT_SECRET"]
  #         }
  #     })
  #     client.authorization = secrets.to_authorization
  #     client.authorization.grant_type = "refresh_token"

  #     client.authorization.refresh!
  #     current_user.update_attribute(:access_token, client.authorization.access_token)
  #     current_user.update_attribute(:refresh_token, client.authorization.refresh_token)
  #     retry
  # end

  # def upload
  #   respond_to do |format|
  #     format.html { render :upload_video }
  #   end
  #   required = [:name, :email]
  #   form_complete = true
  #   required.each do |f|
  #     if params.has_key? f and not params[f].blank?
  #       # that's good news. do nothing
  #     else
  #       form_complete = false
  #     end
  #   end
  #   if form_complete
  #     format.html { render :name }
  #     form_status_msg = 'Thank you for your feedback!'
  #   else
  #     form_status_msg = 'Please fill in all the remaining form fields and resubmit.'
  #   end
  # end

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

  def oauth2callback
  end
end
