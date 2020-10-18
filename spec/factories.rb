FactoryBot.define do
  factory :provider1, class: Provider do
    send_url {'https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1'}
    active {true}
    percentage_used {0.70}
    actual_percentage_used {0.0}
    percentage_failed {0.0}
    count {0}
    failed_count {0}
    total_messages_sent {0}
  end

  factory :provider2, class: Provider do
    send_url {'https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2'}
    active {true}
    percentage_used {0.70}
    actual_percentage_used {0.0}
    percentage_failed {0.0}
    count {0}
    failed_count {0}
    total_messages_sent {0}
  end

  factory :message1, class: Message do
    to_number {1112223333}
    message {"This is my message"}
    callback_url {"http://4020f9bc823c.ngrok.io/verify"}
  end

  factory :message2, class:Message do
    to_number {1112223333}
    message {"This is my message"}
    callback_url {"http://4020f9bc823c.ngrok.io/verify"}
    sent_message_id {"eba3254c-9a8d-404b-b388-ca4c7f9bc611"}
    status {"delivered"}
    queued {false}
    code {200}
    provider_id {21}
    sent_time {"2020-10-16T15:04:09.547Z"}
    response_time {"2020-10-16T15:04:09.706Z"}
  end
end