class CalendarEvent
  attr_reader :name, :calendar_name, :color

  def initialize(calendar:, event:)
    @name = event.summary
    @start = event.start
    @end = event.end
    @calendar_name = calendar.summary
    @color = calendar.background_color
  end

  def start
    datetime_to_string(@start)
  end

  def end
    datetime_to_string(@end)
  end

  private

  def datetime_to_string(datetime)
    if datetime.date_time
      datetime.date_time.strftime("%H:%M")
    else
      case datetime.date
      when Date.today - 1
        "Yesterday"
      when Date.today
        "Today"
      when Date.today + 1
        "Tomorrow"
      else
        datetime.date.strftime("%a, %b %d (All Day)")
      end
    end
  end
end
