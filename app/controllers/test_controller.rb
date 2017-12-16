require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets'

class TestController < ApplicationController
  def index
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/calendar.readonly',
      :redirect_uri => 'http://localhost:3000/oauth2callback',
      :additional_parameters => {
        "access_type" => "offline",         # offline access
        "include_granted_scopes" => "true"  # incremental auth
      }
    )
    auth_uri = auth_client.authorization_uri.to_s
    redirect_to auth_uri
  end

  def this_is_a_test
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.code = params[:code]
    auth_client.redirect_uri = 'http://localhost:3000/oauth2callback'
    auth_client.fetch_access_token!
    session[:credentials] = auth_client.to_json
    redirect_to '/success'
  end

  def success
    client_opts = JSON.parse(session[:credentials])
    auth_client = Signet::OAuth2::Client.new(client_opts)
    service = Google::Apis::CalendarV3::CalendarService.new
    calendar_id = 'primary'
    # Currently shows 12 hours before and 12 hours after
    @response = service.list_events(calendar_id,
                                   single_events: true,
                                   order_by: 'startTime',
                                   time_min: (Time.now - 12.hour).iso8601,
                                   time_max: (Time.now + 12.hour).iso8601,
                                   options: { authorization: auth_client })
    binding.pry
  end
end
