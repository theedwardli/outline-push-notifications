# TODO: Create singleton message_client and reuse
module MessagesHelper
  def valid_number? number
    begin
      response = lookup_client.phone_numbers.get(number)
      response.phone_number # if invalid, throws an exception. if valid, no problems.
      return true
    rescue => e
      return false
    end
  end

  def send_pin number, pin
    message_client.messages.create(
      to: number,
      from: ENV['TWILIO_NUMBER'],
      body: "Your PIN is #{pin}"
    )
  end

  def send_already_subscribed_message number
    message_client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: number,
      body: "You are already subscribed to The Outline."
    )
  end

  def send_error_message number
    message_client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: number,
      body: "Something went wrong. Please try again later."
    )
  end

  def send_subscribe_message number
    message_client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: number,
      body: "You have subscribed to notifications from The Outline. To unsubscribe, text \"UNSUB\" to this number."
    )
  end

  def send_unsubscribe_message number
    message_client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: number,
      body: "You have been unsubscribed from notifications. To resubscribe, text \"SUB\" to this number."
    )
  end

  private

    def message_client
      Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_SECRET"]
    end

    def lookup_client
      Twilio::REST::LookupsClient.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_SECRET"])
    end
end
