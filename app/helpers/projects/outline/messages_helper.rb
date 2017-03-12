module Projects::Outline::MessagesHelper
	def boot_twilio
		Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_SECRET"]
  end
end
