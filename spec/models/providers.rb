require 'rails_helper'
RSpec.describe Provider, :type => :model do
    provider1_params = {send_url:'https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider1',active:true,percentage_used:0.70,actual_percentage_used:0.7,percentage_failed:0.0,count:7,failed_count:0,attempts:15,total_messages_sent:10}
    provider2_params = {send_url:'https://jo3kcwlvke.execute-api.us-west-2.amazonaws.com/dev/provider2',active:true,percentage_used:0.30,actual_percentage_used:0.2,percentage_failed:0.1,count:2,failed_count:1,attempts:15,total_messages_sent:10}

    it "test self.calculate_percentage_used(providers): Check increment of total message sent" do
      p1 = Provider.create(provider1_params)
      p2 = Provider.create(provider2_params)

      providers = Provider.all
      Provider.calculate_percentage_used(providers)

      provider1 = Provider.where(:id=>p1.id).first
      provider2 = Provider.where(:id=>p2.id).first
      (expect(provider1.total_messages_sent).to eq(11)) && (expect(provider2.total_messages_sent).to eq(11))
    end

    it "test self.calculate_percentage_used(providers): Check actual percentage used calculation" do
      p1 = Provider.create(provider1_params)
      p2 = Provider.create(provider2_params)

      providers = Provider.all
      Provider.calculate_percentage_used(providers)

      provider1 = Provider.where(:id=>p1.id).first
      provider2 = Provider.where(:id=>p2.id).first
      (expect(provider1.actual_percentage_used).to eq(0.7)) && (expect(provider2.actual_percentage_used).to eq(0.3))
    end

    it "test self.update_count(providers,current_provider): Check provider count is incremented" do
      p1 = Provider.create(provider1_params)
      p2 = Provider.create(provider2_params)

      providers = Provider.all
      Provider.update_count(providers,p1)

      provider1 = Provider.where(:id=>p1.id).first
      provider2 = Provider.where(:id=>p2.id).first
      (expect(provider1.count).to eq(8)) && (expect(provider2.count).to eq(2))
    end

    it "test self.update_failed_count: Check provider failed_count is incremented" do
      p1 = Provider.create(provider1_params)
      p2 = Provider.create(provider2_params)

      providers = Provider.all
      Provider.update_failed_count(providers,p1)

      provider1 = Provider.where(:id=>p1.id).first
      provider2 = Provider.where(:id=>p2.id).first
      (expect(provider1.failed_count).to eq(1)) && (expect(provider2.failed_count).to eq(1))
    end

    it "test self.calculate_percentage_failed(providers): Check provider percentage_failed calculation" do
      p1 = Provider.create(provider1_params)
      p2 = Provider.create(provider2_params)

      providers = Provider.all
      Provider.calculate_percentage_failed(providers)

      provider1 = Provider.where(:id=>p1.id).first
      provider2 = Provider.where(:id=>p2.id).first

      (expect(provider1.percentage_failed).to eq(0.0)) && (expect(provider2.percentage_failed).to eq(0.666666666666667e-1))
    end

end