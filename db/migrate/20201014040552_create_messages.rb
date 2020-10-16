class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      #message number is to be sent to
      t.column :to_number,:string
      #actual message
      t.column :message,:string
      #callback url
      t.column :callback_url,:string
      #message id returned from provider
      t.column :sent_message_id, :uuid
      #what was the end result of the message sent
      t.column :status, :string
      #is messaged queued to be sent
      t.column :queued, :boolean, :default=>false
      #http response code returned from provide
      t.column :code, :string
      #which provider sent message
      t.column :provider_id,:int
      #what time did message get sent
      t.column :sent_time, :timestamp
      #when did we receive the callback
      t.column :response_time,:timestamp
      t.timestamps
    end
  end
end
