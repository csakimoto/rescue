require 'rails_helper'
describe "get all message route", :type => :request do
  let!(:message) {FactoryBot.create_list(:message1, 20)}
  before {get '/message'}

  it 'returns all messages' do
    expect(JSON.parse(response.body).size).to eq(20)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end

describe "post a message route", :type => :request do
  before do
    post '/message', params: {:to_number=>'1112223333',:message=> 'This is my message',:callback_url=>'http://4020f9bc823c.ngrok.io/verify'}
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end

describe "post a send_messages route", :type => :request do
  before do
    post '/send_messages'
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end

describe "post a verify route", :type => :request do
  before do
    post '/verify', params: {:callback=>{:message_id=>'00000',:status=>'delivered'}}
  end
  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end