require_relative 'tax_strategy'

class GoodsTaxStrategy < TaxStrategy
  def calculate(transaction, vat_service)
      return vat_service.fetch_rate("ES")
  end
end