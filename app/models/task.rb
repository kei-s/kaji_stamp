class Task < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: :true

  before_save :update_google_calendar_event
  after_destroy :destroy_google_calendar_event

  private
  def cal
    Google::Calendar.new(:username => ENV['GOOGLE_CALENDAR_USERNAME'],
                         :password => ENV['GOOGLE_CALENDAR_PASSWORD'],
                         :calendar => ENV['GOOGLE_CALENDAR_ID'])
  end

  def update_google_calendar_event
    event = cal.find_or_create_event_by_id(self.cal_event_id) do |e|
      e.title = self.name
      e.start_time = self.completed_at - (60 * 60) # seconds * min * hours
      e.end_time = self.completed_at # seconds * min * hours
    end
    self.cal_event_id = event.id
  end

  def destroy_google_calendar_event
    cal.find_event_by_id(self.cal_event_id).try(:delete)
  end
end
