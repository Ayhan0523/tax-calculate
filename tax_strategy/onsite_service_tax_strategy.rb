require_relative 'tax_strategy'

class OnsiteServiceTaxStrategy < TaxStrategy
  def calculate(transaction, vat_service)
    return vat_service.fetch_rate("ES") if transaction.service.service_in_spain?
    0 # No tax applied outside Spain    
  end
end
