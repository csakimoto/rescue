class CallbackController < ApplicationController
  # verify callback of sent message and update related message on status
  def verify
    if Message.update_callback_attr(callback_params['message_id'],callback_params['status'])
      render json: 'OK'
    else
      render json: 'Error'
    end
  end

  private
  def callback_params
    params.require(:callback).permit(:message_id,:status)
  end
end
