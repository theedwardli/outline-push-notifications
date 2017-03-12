class Projects::Outline::Subscriber < ActiveRecord::Base
  # Normalizes the attribute itself before validation
  phony_normalize :phone, default_country_code: 'US'

	validates_plausible_phone :phone, presence: true
end
