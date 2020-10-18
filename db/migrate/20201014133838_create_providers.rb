class CreateProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :providers do |t|
      #provider endpoint
      t.column :send_url,:string
      #percentage we would like to see being used during load balancing
      t.column :percentage_used, :decimal
      #actual percentage being
      t.column :actual_percentage_used, :decimal
      #percentage provider fails for 500 status not the actual failed sent message within provider
      t.column :percentage_failed,:decimal
      #number of messages sent via this provider
      t.column :count,:integer, :default=>0
      #number of messages where provider returned 500 status
      t.column :failed_count,:integer, :default=>0
      #attempt message was sent
      t.column :attempts,:integer,:default=>0
      #total messages sent with 200 status
      t.column :total_messages_sent,:integer
      #is the provider still valid
      t.column :active,:boolean
      t.timestamps
    end
  end
end
