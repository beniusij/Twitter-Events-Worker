class CleanWorker
  include Sidekiq::Worker

  def perform
    delete_processed
    delete_invalid
  end

  private

  def delete_processed
    RawTweet.where(is_processed: true).delete_all
  end

  def delete_invalid
    conditions = {
        is_checked: true,
        is_valid:   false
    }

    RawTweet.where(conditions).delete_all
  end
end
