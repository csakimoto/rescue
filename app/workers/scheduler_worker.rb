require 'sidekiq-scheduler'
class SchedulerWorker
  include Sidekiq::Worker

  def perform(*args)
    #send queued messages
    Message.send_message()
  end
end
