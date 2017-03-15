class Projects::Outline::MessagesController < ApplicationController
	include Projects::Outline::MessagesHelper
	skip_before_filter :verify_authenticity_token

  def reply
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
	  	new_subscriber = Projects::Outline::Subscriber.new({ phone: phone_number, verified: true })
	  	begin
	  		new_subscriber.save!
	  	rescue ActiveRecord::RecordNotUnique
	  		Rails.logger.info "#{phone_number} is already subscribed"
		    send_already_subscribed_message phone_number
		  rescue ActiveRecord::RecordInvalid
	  		Rails.logger.error "Could not add subscription for #{phone_number} via text"
	  		send_error_message phone_number
		  else
	  		Rails.logger.info "Added subscription for #{phone_number} via text"
		    send_subscribe_message phone_number
		  end
	  end

	  def unsubscribe phone_number
	    # This is very hacky. Only doing this because I had issues with Trailblazer Operations not being recognized.
	  	subscriber = Projects::Outline::Subscriber.find_by_phone(phone_number)
	  	if subscriber.destroy
	  		Rails.logger.error "Removed subscription for #{phone_number} via text"
		    send_unsubscribe_message phone_number
		  else
	  		Rails.logger.error "Could not remove subscription for #{phone_number} via text"
		  	send_error_message phone_number
		  end
	  end
end
