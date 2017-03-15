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
        Rails.logger.error "Validations failed"
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
    # TODO: delete pin after some minutes?
    @projects_outline_subscriber = Projects::Outline::Subscriber.find_by(phone: params[:hidden_phone])
    @projects_outline_subscriber.verify_pin(params[:pin])
    if @projects_outline_subscriber.verified
      send_subscribe_message @projects_outline_subscriber.phone
    end
    respond_to do |format|
      format.html { redirect_to new_projects_outline_subscriber_path }
      format.js
    end
  end

  private

    def set_projects_outline_subscriber
      @projects_outline_subscriber = Projects::Outline::Subscriber.find(params[:id])
    end

    def projects_outline_subscriber_params
      params.require(:projects_outline_subscriber).permit(:phone)
    end

    def subscriber_exists_responder
      respond_to do |format|
        format.js { render 'phone_exists.js.erb' }
      end
    end

    def resend_pin_responder
      @projects_outline_subscriber.generate_pin
      send_pin(@projects_outline_subscriber.phone, @projects_outline_subscriber.pin)
      respond_to do |format|
        format.js { render 'resend.js.erb' }
      end
    end

    def new_subscriber_responder
      @projects_outline_subscriber.generate_pin
      send_pin(@projects_outline_subscriber.phone, @projects_outline_subscriber.pin)
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
