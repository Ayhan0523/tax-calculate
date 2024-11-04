require_relative '../transaction_result'

class TaxStrategy
	def calculate(transaction, vat_service)
		raise NotImplementedError, "Subclasses must implement the `calculate` method."
	end
end
