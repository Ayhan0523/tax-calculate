require_relative 'tax_strategy'

class GoodsTaxStrategy < TaxStrategy
  def calculate(transaction, vat_service)
    if transaction.buyer_in_spain?
      return vat_service.fetch_rate("ES")
    elsif transaction.buyer_in_eu?
      return transaction.buyer_is_company? ? 0 : vat_service.fetch_rate(transaction.buyer_country)
    else
      return 0 #Export, no tax applied
    end
  end
end