class SendTextJob < ApplicationJob
  queue_as :default

  def perform(*args)
    messages = Message.get_unsent
    if messages.present?
      #get current providers
      providers = Provider.where("active=true").all
      messages.update_attribute('queued',true)
      Message.send_message(messages,providers)
    end
  end
end
