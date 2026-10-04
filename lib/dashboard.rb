require "slim"
require "faraday"
# require "icalendar"
require "icalendar/recurrence"

require "google/apis/calendar_v3"
require "googleauth"

require_relative "calendar_event"

class Dashboard
  SCOPE = "https://www.googleapis.com/auth/calendar.readonly"

  def render
    Slim::Template.new("web/template.slim").render(Object.new, events:)
  end

  private

  def google_connected?

  end

  def events
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = google_credentials
    calendar_list = service.list_calendar_lists

    return "No calendars" if calendar_list.items.empty?

    calendar_list.items.flat_map do |calendar|
      next if calendar.access_role == "freeBusyReader"

      service.list_events(
        calendar.id,
        max_results: 50,
        single_events: true,
        order_by: "startTime",
        time_min: Date.today.to_time.iso8601,
        time_max: (Date.today + 5).to_time.iso8601
      ).items.map do |event|
        CalendarEvent.new(calendar:, event:)
      end
    end
  end

  def google_credentials
    Google::Auth::UserRefreshCredentials.new(
      client_id: ENV["GOOGLE_CLIENT_ID"],
      client_secret: ENV["GOOGLE_CLIENT_SECRET"],
      scope: SCOPE,
      refresh_token: ENV["GOOGLE_REFRESH_TOKEN"]
    )
  end
end
