require 'google/apis/youtube_v3'
require "google/api_client/client_secrets.rb"

class YoutubeController < ApplicationController
    def youtubeListProva
        client = get_google_youtube_client current_user
        @dati = client.list_channels("UCTo-Iq6sT4-tevlofZzid4A")
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
