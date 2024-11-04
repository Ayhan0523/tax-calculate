require_relative 'tax_strategy'

class OnsiteServiceTaxStrategy < TaxStrategy
  def calculate(transaction, vat_service)
    rate= vat_service.fetch_rate("ES") if transaction.service.service_in_spain?
    TransactionResult.new(rate, ['service', 'onsite'])
  end
end
