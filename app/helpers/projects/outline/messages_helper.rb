module Projects::Outline::MessagesHelper
	def message_client
		Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_SECRET"]
  end

  def lookup_client
		Twilio::REST::LookupsClient.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_SECRET"])
  end
end
