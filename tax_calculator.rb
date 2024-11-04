require_relative './tax_strategy/tax_strategy'
require_relative './tax_strategy/onsite_service_tax_strategy'
require_relative './tax_strategy/digital_service_tax_strategy'
require_relative './tax_strategy/goods_tax_strategy'

class TaxCalculator
	def initialize(vat_service)
		@vat_service = vat_service
	end

	def calculate_tax(transaction)
		strategy_klass = get_strategy(transaction)
		strategy = strategy_klass.new
		strategy.calculate(transaction, @vat_service)
	end

	private

	def get_strategy(transaction)
		case transaction.type
		when Transaction::PHYSICAL
			GoodsTaxStrategy
		when Transaction::DIGITAL
			DigitalServiceTaxStrategy
		when Transaction::ONSITE
			OnsiteServiceTaxStrategy
		else
			raise "Incorrect transaction type"
		end
	end
end
