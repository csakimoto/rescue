require 'rails_helper'
RSpec.describe Message, :type => :model do
  #provider_params
  provider1_params = {send_url:'https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1',active:true,percentage_used:0.70,actual_percentage_used:0.7,percentage_failed:0.0,count:7,failed_count:0,attempts:15,total_messages_sent:10}
  provider2_params = {send_url:'https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2',active:true,percentage_used:0.30,actual_percentage_used:0.2,percentage_failed:0.1,count:2,failed_count:1,attempts:15,total_messages_sent:10}

  #params update after callback
  sent_params = {:to_number=>1112223333, :message =>"This is my message", :callback_url=>"http://4020f9bc823c.ngrok.io/verify",
            :sent_message_id=>"eba3254c-9a8d-404b-b388-ca4c7f9bc611" ,:status=>"delivered", :queued=>false, :code=>200,
            :provider_id=>21,:sent_time=>"2020-10-16T15:04:09.547Z", :response_time=>"2020-10-16T15:04:09.706Z"}
  #unsent message params
  unsent_params = {:to_number=>1112223333, :message =>"This is my message", :callback_url=>"http://4020f9bc823c.ngrok.io/verify"}

  unsent_failed_params = {:to_number=>1112223333, :message =>"This is my message", :callback_url=>nil}
  unsent_params_invalid = {:to_number=>3112223333, :message =>"This is my message", :callback_url=>"http://4020f9bc823c.ngrok.io/verify",
                   :sent_message_id=>nil ,:status=>nil, :queued=>false, :code=>nil,
                   :provider_id=>nil,:sent_time=>nil, :response_time=>nil}

  it "test self.update_callback_attr(message_id,status) updates messaege with new status based on message_id" do
    m =Message.create(sent_params)
    #call update_callback_attr
    Message.update_callback_attr(m.sent_message_id,"Invalid")
    um = Message.where(:id=>m.id).first

    expect(um.status).to eq "Invalid"
  end

  it "test if self.get_unsent() gets unsent message and puts message into queued state " do
    m =Message.create(unsent_params)
    #call update_callback_attr
    Message.get_unsent()
    um = Message.where(:id=>m.id).first
    (expect(um.status).to eq nil) && (expect(um.sent_message_id).to eq nil) && (expect(um.queued).to eq true)
  end

  it "test self.send_messages() valid params" do
    m=Message.create(unsent_params)
    Message.send_messages()
    um = Message.where(:id=>m.id).first
    puts um.code
    (expect(um.code).not_to eq(200))
  end

  it "test self.send_messages() valid params" do
    m=Message.create(unsent_params)
    Message.send_messages()
    um = Message.where(:id=>m.id).first
    (expect(um.code).not_to eq(200))
  end

  it "test self.handle_500_status()" do
    p1 = Provider.create(provider1_params)
    p2 = Provider.create(provider2_params)
    providers = Provider.all
    provider_place_holder=0
    place_holder = Message.handle_500_status(providers,provider_place_holder)
    (expect(place_holder).not_to eq(1))
  end

  it "test self.handle_200_status()" do
    p1 = Provider.create(provider1_params)
    p2 = Provider.create(provider2_params)
    providers = Provider.all
    provider_place_holder=0
    str_status =""
    m = Message.create(unsent_params)

    while str_status!=200
      response = Faraday.post(providers[provider_place_holder].send_url, m.to_json, "Content-Type" => "application/json")
      str_status=response.status
    end
    parsed_json_response = ActiveSupport::JSON.decode(response.body)
    Message.handle_200_status(parsed_json_response,providers,provider_place_holder)

    up = Provider.where(:id=>p1.id).first

    (expect(up.count).to eq(8))
  end
end
