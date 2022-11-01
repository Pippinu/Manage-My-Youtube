require 'google/apis/youtube_v3'
require "google/api_client/client_secrets.rb"

class YoutubeController < ApplicationController
  YOUTUBE_UPLOAD_SCOPE = 'https://www.googleapis.com/auth/youtube.upload'
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

    def youtubeListProva
        client = get_google_youtube_client current_user
        
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
        @dati = client.list_channels("UCJgEAT_2X9rkjjyq5cfZ-GQ")
    end

    def list
      client = get_google_youtube_client current_user
        
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
        
        part='snippet,contentDetails,statistics'
        @response = client.list_channels(part, "UCJgEAT_2X9rkjjyq5cfZ-GQ").to_json
        item = JSON.parse(@response).fetch("items")[0]

        @lisResp = "This channel's ID is #{item.fetch("id")}. " +
              "Its title is '#{item.fetch("snippet").fetch("title")}', and it has " +
              "#{item.fetch("statistics").fetch("viewCount")} views."

        retry

    end


    def uploadProva
      client = get_google_youtube_client current_user
      youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
        
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

        respond_to do |format|
          format.html { render :upload_video }
        end
        required = [:name, :email, :reply, :feedback_type, :message]
        form_complete = true
        required.each do |f|
          if params.has_key? f and not params[f].blank?
            # that's good news. do nothing
          else
            form_complete = false
          end
        end
        if form_complete
          form_status_msg = 'Thank you for your feedback!'
        else
          form_status_msg = 'Please fill in all the remaining form fields and resubmit.'
        end
        format.html { render :contact, locals: { status_msg: form_status_msg } }

        begin
          body = {
            :snippet => {
              :title => opts[:title],
              :description => opts[:description],
              :tags => opts[:keywords].split(','),
              :categoryId => opts[:category_id],
            },
            :status => {
              :privacyStatus => opts[:privacy_status]
            }
          }
      
          videos_insert_response = client.execute!(
            :api_method => youtube.videos.insert,
            :body_object => body,
            :media => Google::APIClient::UploadIO.new(opts[:file], 'video/*'),
            :parameters => {
              :uploadType => 'resumable',
              :part => body.keys.join(',')
            }
          )
      
          videos_insert_response.resumable_upload.send_all(client)
      
          @inserted = "Video id '#{videos_insert_response.data.id}' was successfully uploaded."
        rescue Google::APIClient::TransmissionError => e
          @resBody = e.result.body
        end
    end


    def upload
      respond_to do |format|
        format.html { render :upload_video }
      end
      required = [:name, :email]
      form_complete = true
      required.each do |f|
        if params.has_key? f and not params[f].blank?
          # that's good news. do nothing
        else
          form_complete = false
        end
      end
      if form_complete
        format.html { render :name }
        form_status_msg = 'Thank you for your feedback!'
      else
        form_status_msg = 'Please fill in all the remaining form fields and resubmit.'
      end
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
