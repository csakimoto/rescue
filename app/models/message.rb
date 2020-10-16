class Message < ApplicationRecord
  def self.send_message()
    #get unsent messages
    messages = Message.get_unsent()
    if messages.present?
      #used to keep track of number of attempt we try to send message
      attempt = 0

      # Cycle through messages and post to the provider
      # Try to send three times if the post fails
      # If the send fails more than three times the message is considered invalid

      messages.each do |message|
        begin
          #get current providers
          providers = Provider.where("active=true").all

          #Post message data to provider
          number_of_providers =providers.length

          #post text message to provider
          while (attempt<4)  do

            #choose which provider to start with based on percentage to be used
            provider_place_holder = Provider.choose_provider(providers)

            #post message to provider
            response = Faraday.post(providers[provider_place_holder].send_url, message.to_json, "Content-Type" => "application/json")

            #parse JSON reponse to pick up message_id
            parsed_response_body=ActiveSupport::JSON.decode(response.body)

            case response.status
              #if repsonse status is 500 then try other provider
            when 500
              #record 500 status failure related to the provider
              Provider.update_failed_count(providers,providers[provider_place_holder])
              #if reached maximum number of providers then go to other provider
              if provider_place_holder.next==number_of_providers
                provider_place_holder=0
              else
                provider_place_holder=provider_place_holder.next
              end
            when 200
              #if message sent to provider successful record time sent,message id, take out of queue, set response status from provider, and which provider sent message.
              message.update(:sent_message_id=>parsed_response_body['message_id'],:queued=>false,:code =>response.status,:provider_id=>providers[provider_place_holder].id,:sent_time=>Time.now)

              #update statistics of providers
              Provider.update_count(providers,providers[provider_place_holder])

              #break from case statement
              break;
            else
              #all other http response codes are captured here
              message.update(:sent_message_id=>parsed_response_body['message_id'],:queued=>false,:code =>response.status,:status=>'Failed')
              break;
            end
              attempt=attempt.next
          end

          #if after 5 attempts and no provider is available set message as failed
          if response.status==500
            #remove from queue and set as failed.
            message.update(:queued=>false,:status=>'Failed')
          end
          #reset attempt
          attempt=0
        rescue StandardError => e
          message.update(:queued=>false,:status=>'Invalid')
          next
        end
      end
    else
      return false
    end
  end

  #update callback message status based on sent_message_id from provider
  def self.update_callback_attr(message_id,status)

    #get message by sent_message id
    message = Message.where(:sent_message_id=>message_id).first

    #if message.status is updated successfully return
    if message.present?
      #update messages status on call back
      message.update(:status=>status,:response_time=>Time.now)
      return true
    else
      return false
    end
  end

  #get batch of unsent messages to be sent
  def self.get_unsent()
    # get all messages that have not been sent
    begin
      messages = Message.where('sent_message_id is null and queued is false and status is null').all
      #update messages as being queued
      messages.update(:queued=>true)
      return messages
    rescue StandardError => e
      return e.message
    end
  end
end
