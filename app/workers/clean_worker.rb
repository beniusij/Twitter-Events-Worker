class CleanWorker
  include Sidekiq::Worker

  sidekiq_options unique: :until_and_while_executing, lock_expiration: 12 * 60

  def perform
    delete_processed
    delete_old
  end

  private

  def delete_processed
    RawTweet.where(is_processed: true).delete_all
  end

  def delete_old
    Event.delete_old_events
  end
end
