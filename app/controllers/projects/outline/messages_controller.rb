class Projects::Outline::MessagesController < ApplicationController
	include Projects::Outline::MessagesHelper
	skip_before_filter :verify_authenticity_token

  def reply
  	@twilio_client = message_client
    from_number = params["From"]
    message_body = params["Body"]
    case message_body
    when "SUB"
    	subscribe from_number
    when "UNSUB"
    	unsubscribe from_number
    end
  end

  private 

	  def subscribe phone_number
	  	# This is very hacky. Only doing this because I had issues with Trailblazer Operations not being recognized.
	  	new_subscriber = Projects::Outline::Subscriber.new({ phone: phone_number })
	  	begin 
	  		new_subscriber.save!
	  	rescue ActiveRecord::RecordNotUnique
	  		Rails.logger.info("Could not add subscription for #{phone_number} via text: RecordNotUnique")
		    @twilio_client.messages.create(
		      from: ENV["TWILIO_NUMBER"],
		      to: phone_number,
		      body: "You are already subscribed to The Outline."
		    )
		  rescue ActiveRecord::RecordInvalid
	  		Rails.logger.info("Could not add subscription for #{phone_number} via text")
		  	@twilio_client.messages.create(
		      from: ENV["TWILIO_NUMBER"],
		      to: phone_number,
		      body: "Something went wrong and we couldn't add your subscription. Please try again later."
		    )
		  else 
	  		Rails.logger.info("Added subscription for #{phone_number} via text")
		    @twilio_client.messages.create(
		      from: ENV["TWILIO_NUMBER"],
		      to: phone_number,
		      body: "You have subscribed to notifications from The Outline. To unsubscribe, text \"UNSUB\" to this number."
		    )
		  end
	  end

	  def unsubscribe phone_number
	    # This is very hacky. Only doing this because I had issues with Trailblazer Operations not being recognized.
	  	subscriber = Projects::Outline::Subscriber.find_by_phone(phone_number)
	  	if subscriber.destroy
	  		Rails.logger.info("Removed subscription for #{phone_number} via text")
		    @twilio_client.messages.create(
		      from: ENV["TWILIO_NUMBER"],
		      to: phone_number,
		      body: "You have been unsubscribed from notifications. To resubscribe, text \"SUB\" to this number."
		    )
		  else 
	  		Rails.logger.info("Could not remove subscription for #{phone_number} via text")
		  	@twilio_client.messages.create(
		      from: ENV["TWILIO_NUMBER"],
		      to: phone_number,
		      body: "Something went wrong and we couldn't remove your subscription. Please try again later."
		    )
		  end
	  end
end
