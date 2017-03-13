class Projects::Outline::SubscribersController < ApplicationController
  include Projects::Outline::MessagesHelper 
  skip_before_filter :verify_authenticity_token

  before_action :set_projects_outline_subscriber, only: [:show, :edit, :update, :destroy] # fine tune this

  # GET /projects/outline/subscribers/new
  def new
    @projects_outline_subscriber = Projects::Outline::Subscriber.new
  end

  # POST /projects/outline/subscribers
  # POST /projects/outline/subscribers.json
  def create
    @projects_outline_subscriber = Projects::Outline::Subscriber.new(projects_outline_subscriber_params)
    begin 
      if valid_number?(@projects_outline_subscriber.phone) && @projects_outline_subscriber.save 
        Rails.logger.info "Validations complete"
        new_subscriber_responder
      else
        Rails.logger.info "Validations failed"
        bad_phone_responder
      end
    rescue ActiveRecord::RecordNotUnique
      @projects_outline_subscriber = Projects::Outline::Subscriber.find_by_phone(@projects_outline_subscriber.phone)
      if @projects_outline_subscriber.verified?
        Rails.logger.info "Subscriber already exists"
        subscriber_exists_responder
      else
        Rails.logger.info "Subscriber isn't verified"
        resend_pin_responder
      end
    end    
  end

  def verify
    # delete pin after some minutes?
    @projects_outline_subscriber = Projects::Outline::Subscriber.find_by(phone: params[:hidden_phone])
    @projects_outline_subscriber.verify_pin(params[:pin])
    message_client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: @projects_outline_subscriber.phone,
      body: "You have subscribed to notifications from The Outline. To unsubscribe, text \"UNSUB\" to this number."
    )
    respond_to do |format|
      format.html { redirect_to new_projects_outline_subscriber_path }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_projects_outline_subscriber
      @projects_outline_subscriber = Projects::Outline::Subscriber.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def projects_outline_subscriber_params
      params.require(:projects_outline_subscriber).permit(:phone)
    end

    def send_pin
      @twilio_client = message_client
      @twilio_client.messages.create(
        to: @projects_outline_subscriber.phone,
        from: ENV['TWILIO_NUMBER'],
        body: "Your PIN is #{@projects_outline_subscriber.pin}"
      )
    end

    def subscriber_exists_responder
      respond_to do |format|
        format.js { render 'phone_exists.js.erb' }
      end
    end

    def resend_pin_responder
      @projects_outline_subscriber.generate_pin
      send_pin
      respond_to do |format|
        format.js { render 'resend.js.erb' }
      end
    end

    def new_subscriber_responder
      @projects_outline_subscriber.generate_pin
      send_pin
      respond_to do |format|
        format.js { render 'create.js.erb' }
      end
    end

    def bad_phone_responder
      respond_to do |format|
        format.js { render 'bad_phone.js.erb' }
      end
    end

    def valid_number? number
      begin
        response = lookup_client.phone_numbers.get(number)
        response.phone_number # if invalid, throws an exception. if valid, no problems.
        return true
      rescue => e
        return false
      end
    end
end
