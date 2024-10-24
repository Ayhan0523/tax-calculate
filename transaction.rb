class Transaction
	attr_accessor :buyer_country, :buyer_type, :service_location, :type
	
	def initialize(buyer_country, buyer_type, service_location, type)
		@buyer_country = buyer_country
		@buyer_type = buyer_type
		@service_location = service_location
		@type = type
	end

	def buyer_in_spain?
		@buyer_country == "ES"
	end

	def buyer_in_eu?
		["FR", "DE", "IT", "ES"].include?(@buyer_country) #Simplified EU check
	end

	def buyer_is_company?
		@buyer_type == :buyer_is_company
	end

	def service_in_spain?
		@service_location == "ES"
	end
end