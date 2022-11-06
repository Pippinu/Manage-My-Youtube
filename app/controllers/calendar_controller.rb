require "google/apis/calendar_v3"
require 'googleauth'
require 'googleauth/stores/file_token_store'

require "google/api_client/client_secrets.rb"
require 'open-uri'
require 'date'

require 'fileutils'
require 'json'

require 'securerandom'

require 'rubygems'

#FUNZIONA TUTTO, SISTEMARE DOPPIO EVENTO

class CalendarController < ApplicationController

    # SCOPE = ['https://www.googleapis.com/auth/calendar',
    #         'https://www.googleapis.com/auth/calendar.events',
    #         'https://www.googleapis.com/auth/calendar.events.readonly',
    #         'https://www.googleapis.com/auth/calendar.readonly',
    #         'https://www.googleapis.com/auth/calendar.settings.readonly',
    #         'https://www.googleapis.com/auth/youtube',
    #         'https://www.googleapis.com/auth/youtube.force-ssl',
    #         'https://www.googleapis.com/auth/youtube.readonly',
    #         'https://www.googleapis.com/auth/youtube.upload',
    #         'https://www.googleapis.com/auth/youtubepartner',
    #         'https://www.googleapis.com/auth/youtubepartner-channel-audit']

    # CLIENT_SECRETS_PATH = 'app/controllers/client_secret.json'
    # CREDENTIALS_PATH = "app/controllers/youtube-quickstart-ruby-credentials.yaml"
    # REDIRECT_URI = 'http://localhost:3000/oauth2callback'
    # APPLICATION_NAME = 'Progetto LASSI'

    def new
        @calendar = Calendar.new
    end

    def create
        userID = params[:userID]
        cliente = User.find(userID)
        userEmail = cliente.email

        client = get_google_calendar_client current_user

        # Creo calendar con Google API
        googleCalendar = Google::Apis::CalendarV3::Calendar.new(
            summary: "MMY_USER_#{cliente.full_name}",
            time_zone: 'Europe/Rome'
        )
        createdCalendar = client.insert_calendar(googleCalendar)

        # Creo ACL che permette condivisione del calendario appena creato con il relativo cliente.
        rule = Google::Apis::CalendarV3::AclRule.new(
            scope: {
                type: "user",
                value: userEmail 
            },
            # Attraverso tale role, il cliente avra potere di scrittura eventi ma non di modifica del calendario
            role: "writer"
        )
        # Google API Method per inserire le ACL appena create al Google Calendar
        acl = client.insert_acl(createdCalendar.id, rule)

        # Aggiungo il Calendar appena creato al DB Calendars 
        calendarToSave = newCalendar(createdCalendar, userID, acl.id)
        # Da sistemare, salva ma da errore di conversione
        calendarToSave.save!

        redirect_to '/manager/singleone?cliente='+ cliente.id.to_s

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

    def delete
        userID = params[:userID]

        client = get_google_calendar_client current_user
        calendar = Calendar.find_by(managerId: current_user.id, userId: userID)

        if calendar
            client.delete_acl(calendar.calendarId, calendar.acl_id)
            client.delete_calendar(calendar.calendarId)

            Calendar.delete(calendar.id)
        end
        redirect_to '/manager/singleone?cliente='+ userID.to_s

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

    # OK Cliente e OK Manager
    def createEvent
        @event = Event.new

        if current_user.ruolo === "manager"
            @userID = params[:userID]
        else
            @userID = params[:managerID]
        end
    end

    # OK Cliente e OK Manager, DA SISTEMARE DOPPIO EVENTO
    def createEventConfirm
        event = params[:event]
        userID = event[:userID]

        client = get_google_calendar_client current_user

        # Da sistemare con tutti i dati
        # @newEvent = Event.new()
        # @newEvent.summary = event[:summary]
        # @newEvent.save

        # Controlla la scelta di creazione della conferenza meet dal form
        if event[:meetConference]
            conferenceData = {
                create_request: {
                   request_id: SecureRandom.uuid
                }
            }
        else
            conferenceData = nil
        end 

        attendeeRecord = User.find_by(id: userID)
        attendee =  Google::Apis::CalendarV3::EventAttendee.new(
            display_name: attendeeRecord.full_name,
            email: attendeeRecord.email,
            id: attendeeRecord.id, 
            resource: true
        )

        calendarEvent = Google::Apis::CalendarV3::Event.new(
            summary: event[:summary],
            attendees: [attendee],
            creator: Google::Apis::CalendarV3::Event::Creator.new(
                display_name: current_user.full_name,
                email: current_user.email,
                id: current_user.id
            ),
            description: "Prova Evento",
            start: Google::Apis::CalendarV3::EventDateTime.new(
                date: event[:date_attribute_start],
                time_zone: "Europe/Rome"
            ), 
            end: Google::Apis::CalendarV3::EventDateTime.new(
                date: event[:date_attribute_end],
                time_zone: "Europe/Rome"
            ),
            kind: "calendar#event",
            organizer: Google::Apis::CalendarV3::Event::Organizer.new(
                display_name: current_user.full_name,
                email: current_user.email,
                id: current_user.id
            ),
            source: Google::Apis::CalendarV3::Event::Source.new(
                title: "Create Event Method from Calendar Controller",
                url: "http://127.0.0.1/calendar/createCalendar"
            ),
            conference_data: conferenceData
        )

        if current_user.ruolo === "manager"
            calendar = Calendar.find_by(managerId: current_user.id, userId: event[:userID])
        else
            calendar = Calendar.find_by(managerId: event[:userID], userId: current_user.id)
        end

        @createdEvent = client.insert_event(calendar.calendarId, calendarEvent, conference_data_version: 1)

        @eventRecord = Event.new()

        @eventRecord.summary = @createdEvent.summary
        @eventRecord.description = @createdEvent.description
        @eventRecord.start = @createdEvent.start.date
        @eventRecord.end = @createdEvent.end.date
        @eventRecord.meetCode = @createdEvent.conference_data.conference_id
        @eventRecord.calendarID = calendar.calendarId
        @eventRecord.eventID = @createdEvent.id

        if current_user.ruolo === "manager"
            @eventRecord.managerID= current_user.id
            @eventRecord.clientID= attendeeRecord.id
        else
            @eventRecord.managerID= attendeeRecord.id
            @eventRecord.clientID= current_user.id
        end

        @eventRecord.save

        if current_user.ruolo === "manager"
            redirect_to '/manager/singleone?cliente='+ userID.to_s
        else
            redirect_to '/cliente/function'
        end

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

    def editEvent
        @event = Event.find(params[:format])
    end

    def listEvent
        @eventList = Event.all
        if current_user.ruolo === "manager"
            @userID = params[:userID]
        else
            @userID = params[:managerID]
        end
    end

    def reviewEvent
        event = params[:event]
        userID = params[:userID]

        eventDB = Event.find(event[:eventID])

        client = get_google_calendar_client current_user

        eventToEdit = client.get_event(eventDB.calendarID, eventDB.eventID)

        # Modifico l'evento su Google Calendar
        eventToEdit.summary = event[:summary]
        eventToEdit.description = event[:description]
        eventToEdit.start.date = event[:start]
        eventToEdit.end.date = event[:end]
        eventToEdit.conference_data.conference_id = event[:meetCode]

        @editedEvent = client.patch_event(eventDB.calendarID, eventDB.eventID, eventToEdit)

        # Modifico l'evento Active Record
        eventDB.update(
            summary: event[:summary], 
            description: event[:description],
            start: event[:start],
            end: event[:end],
            meetCode: event[:meetCode]
        )

        if current_user.ruolo === "manager"
            redirect_to '/manager/singleone?cliente='+ eventDB.clientID.to_s
        else
            redirect_to '/cliente/function'
        end
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

    def deleteEvent
        eventToDelete = Event.find(params[:event])
        userID = eventToDelete.clientID

        client = get_google_calendar_client current_user

        if client.delete_event(eventToDelete.calendarID, eventToDelete.eventID)
            Event.delete(eventToDelete.id)
        end

        if current_user.ruolo === "manager"
            redirect_to '/manager/singleone?cliente='+ userID.to_s
        else
            redirect_to '/cliente/function'
        end

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

    def get_google_calendar_client current_user
        client = Google::Apis::CalendarV3::CalendarService.new
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

    def newCalendar(calendar, userID, acl_id)
        calendarToSave = Calendar.new(
            calendarId: calendar.id.to_s,
            summary: calendar.summary.to_s,
            managerId: current_user.id.to_s,
            userId: userID.to_s,
            acl_id: acl_id.to_s
        )

        return calendarToSave
    end
end
    