require 'rails_helper'
RSpec.describe Message, :type => :model do

  #params update after callback
  params = {:to_number=>1112223333, :message =>"This is my message", :callback_url=>"http://4020f9bc823c.ngrok.io/verify",
            :sent_message_id=>"eba3254c-9a8d-404b-b388-ca4c7f9bc611" ,:status=>"delivered", :queued=>false, :code=>200,
            :provider_id=>21,:sent_time=>"2020-10-16T15:04:09.547Z", :response_time=>"2020-10-16T15:04:09.706Z"}
  #unsent message params
  unsent_params = {:to_number=>1112223333, :message =>"This is my message", :callback_url=>"http://4020f9bc823c.ngrok.io/verify",
             :sent_message_id=>nil ,:status=>nil, :queued=>false, :code=>nil,
             :provider_id=>nil,:sent_time=>nil, :response_time=>nil}

  unsent_params_invalid = {:to_number=>3112223333, :message =>"This is my message", :callback_url=>"http://4020f9bc823c.ngrok.io/verify",
                   :sent_message_id=>nil ,:status=>nil, :queued=>false, :code=>nil,
                   :provider_id=>nil,:sent_time=>nil, :response_time=>nil}

  it "test self.update_callback_attr(message_id,status) updates messaege with new status based on message_id" do
    m =Message.create(params)
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

  it "test check if phone number beginning with 3 returns invalid" do
    m=Message.create(unsent_params_invalid)
    response = Faraday.post('https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1', m.to_json, "Content-Type" => "application/json")
    (expect(response.body['message_id']).not_to eq(nil))
  end

end
