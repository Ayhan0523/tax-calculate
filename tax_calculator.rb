class TaxCalculator
	def initialize(stragety, vat_service)
		@stragety = stragety
		@vat_service = vat_service
	end

	def calculate_tax(transaction)
		@stragety.calculate(transaction, @vat_service)
	end
end