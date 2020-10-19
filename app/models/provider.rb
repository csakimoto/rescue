class Provider < ApplicationRecord
  #choose provider based on actual percentage used
  def self.choose_provider(providers)
    if providers[0].actual_percentage_used < providers[0].percentage_used
      return 0
    else
      return 1
    end
  end
  #update count of message sent with 200 status from provider
  def self.update_count(providers,current_provider)
    begin
      current_provider.update(:count=>current_provider.count.next,:attempts=>current_provider.attempts.next)
      self.calculate_percentage_used(providers)
    rescue StandardError => e
      return e.message
    end
  end
  #calculate actual percentage used of provider
  def self.calculate_percentage_used(providers)
    begin
      providers.each do |p|
        actual_percentage_used = (p.count.next.to_f/p.total_messages_sent.next.to_f)
        p.update(:actual_percentage_used=>actual_percentage_used,:total_messages_sent=>p.total_messages_sent.next)
      end
    rescue StandardError => e
      return e.message
    end
  end

  #update count of message sent with 500 status from provider
  def self.update_failed_count(providers,current_provider)
    begin
      current_provider.update(:failed_count=>current_provider.failed_count.next,:attempts=>current_provider.attempts.next)
      self.calculate_percentage_failed(providers)
    rescue StandardError => e
      return e.message
    end
  end

  #calculate actual percentage failed of provider based on provider availability and field 500 http response code
  # It's not calculating failed status from callback.
  def self.calculate_percentage_failed(providers)
    begin
      providers.each do |p|
        percentage_failed = p.failed_count.to_f/(p.attempts).to_f
        p.update(:percentage_failed=>percentage_failed)
      end
    rescue StandardError=>e
      return e.message
    end
  end

end
