class SubscribersController < ApplicationController
  include MessagesHelper
  skip_before_filter :verify_authenticity_token

  before_action :set_subscriber, only: [:show, :edit, :update, :destroy] # fine tune this

  # GET /subscribers/new
  def new
    @subscriber = Subscriber.new
  end

  # POST /subscribers
  # POST /subscribers.json
  def create
    @subscriber = Subscriber.new(subscriber_params)
    begin
      if valid_number?(@subscriber.phone) && @subscriber.save
        Rails.logger.info "Validations complete"
        new_subscriber_responder
      else
        Rails.logger.error "Validations failed"
        bad_phone_responder
      end
    rescue ActiveRecord::RecordNotUnique
      @subscriber = Subscriber.find_by_phone(@subscriber.phone)
      if @subscriber.verified?
        Rails.logger.info "Subscriber already exists"
        subscriber_exists_responder
      else
        Rails.logger.info "Subscriber isn't verified"
        resend_pin_responder
      end
    end
  end

  def verify
    # TODO: delete pin after some minutes?
    @subscriber = Subscriber.find_by(phone: params[:hidden_phone])
    @subscriber.verify_pin(params[:pin])
    if @subscriber.verified
      send_subscribe_message @subscriber.phone
    end
    respond_to do |format|
      format.html { redirect_to new_subscriber_path }
      format.js
    end
  end

  private

    def set_subscriber
      @subscriber = Subscriber.find(params[:id])
    end

    def subscriber_params
      params.require(:subscriber).permit(:phone)
    end

    def subscriber_exists_responder
      respond_to do |format|
        format.js { render 'phone_exists.js.erb' }
      end
    end

    def resend_pin_responder
      @subscriber.generate_pin
      send_pin(@subscriber.phone, @subscriber.pin)
      respond_to do |format|
        format.js { render 'resend.js.erb' }
      end
    end

    def new_subscriber_responder
      @subscriber.generate_pin
      send_pin(@subscriber.phone, @subscriber.pin)
      respond_to do |format|
        format.js { render 'create.js.erb' }
      end
    end

    def bad_phone_responder
      respond_to do |format|
        format.js { render 'bad_phone.js.erb' }
      end
    end
end
