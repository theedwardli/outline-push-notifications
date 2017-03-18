require 'digest/sha1'

class Feed
	include Singleton
	include MessagesHelper

	def initialize 
		Rails.logger.info 'Subscribing to The Outline'
		@twilio_client = message_client
		SuperfeedrEngine::Engine.subscribe(self, { retrieve: false })
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
		Rails.logger.info params
		new_items = params['items']

		# Add threading/async in the future
		new_items.each do |item|
			Subscriber.all.where(verified: true).each do |subscriber|
				@twilio_client.messages.create(
			    from: ENV["TWILIO_NUMBER"],
			    to: subscriber.phone,
			    body: "The Outline just published \"#{item["title"]}\". You can read it here: #{item["permalinkUrl"]}"
		    )
			end
		end
	end

	def self.find feed_id
		feed = Feed.instance
		feed if feed.id == feed_id
	end
end
