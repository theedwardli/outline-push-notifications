class Projects::Outline::Subscriber < ActiveRecord::Base
  # Normalizes the attribute itself before validation
  phony_normalize :phone, default_country_code: 'US'

	validates_plausible_phone :phone, presence: true

	def generate_pin
		pin = rand(0000..9999).to_s.rjust(4, "0")
		update(pin: pin)
	end

	def verify_pin entered_pin
		update(verified: true) if self.pin == entered_pin
	end
end
