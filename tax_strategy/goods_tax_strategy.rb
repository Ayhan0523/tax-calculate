require_relative 'tax_strategy'

class GoodsTaxStrategy < TaxStrategy
  def calculate(transaction, vat_service)
    if transaction.buyer_in_spain?
      rate = vat_service.fetch_rate("ES")
      TransactionResult.new(rate, ['good'])
    elsif transaction.buyer_in_eu?
      rate = transaction.buyer_is_company? ? 0 : vat_service.fetch_rate(transaction.buyer_country)
      status = transaction.buyer_is_company? ? 'reverse charge' : ''
      TransactionResult.new(rate, ['good'], status)
    else
      TransactionResult.new(0, ['good'], ['export'])
    end
  end
end
