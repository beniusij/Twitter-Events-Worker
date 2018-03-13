class ProcessWorker
  include Sidekiq::Worker

  # A worker for processing valid tweets and creating events

  def perform
    # Do something
  end

  private

  # Save the event in the table
  def save_event(place, date, time, keywords)
    Events.create do |t|
      t.place     = place
      t.date      = date
      t.time      = time
      t.keywords  = keywords
    end
  end
end
