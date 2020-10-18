class MessageController < ApplicationController

  #create messages from post call
  #this will build a batch of messages to be picked up when background job runs
  def create
    if Message.create(message_params)
      render json: {status: :ok}
    else
      render json: 'Error!'
    end

   end

  #get all messages in database
  def get_all
    if @messages = Message.all
      render json: @messages
    else
      render json: "Error!"
    end

  end

  #Send messages from outside post call
  def send_messages
    if Message.send_messages()
      render json: {status: :ok}
    else
      render json: "Error"
    end
  end

  private
  def message_params
    params.permit(:to_number,:message,:callback_url,:sent_message_id)
  end

end
