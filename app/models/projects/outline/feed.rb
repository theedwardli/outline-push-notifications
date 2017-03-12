require 'digest/sha1'

class Projects::Outline::Feed
	include Singleton
	include Projects::Outline::MessagesHelper

	def initialize 
		Rails.logger.info 'Subscribing to The Outline'
		SuperfeedrEngine::Engine.subscribe(self, { retrieve: false })
		@twilio_client = boot_twilio
	end

	def id
		Digest::SHA1.hexdigest self.class.name
	end

	def url
		'https://theoutline.com/feeds/recent.rss'
	end

	def secret
		Digest::SHA1.hexdigest 'The Outline'
	end

	def notified params
		Rails.logger.info "A new article was published at #{Time.now}"
		new_items = params['items']

		# Add threading/async in the future
		new_items.each do |item|
			Projects::Outline::Subscriber.all.each do |subscriber|
				@twilio_client.messages.create(
			    from: ENV["TWILIO_NUMBER"],
			    to: subscriber.phone,
			    body: "The Outline just published \"#{item["title"]}\". You can read it here: #{item["permalinkUrl"]}"
		    )
			end
		end
	end
end
