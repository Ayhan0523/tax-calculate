require_relative '../digital_service_tax_strategy'
require_relative '../transaction'
require_relative '../vat_service'
require_relative '../tax_strategy'

RSpec.describe DigitalServiceTaxStrategy do
  let(:vat_service) { VatService.new }
  let(:digital_service_tax_strategy) { DigitalServiceTaxStrategy.new }

  describe '#calculate' do
    context 'when the buyer is in Spain' do
      it 'fetches the tax rate for Spain' do
        transaction = Transaction.new("ES", :buyer_is_individual, "ES", :digital_service)
        
        result = digital_service_tax_strategy.calculate(transaction, vat_service)
        
        expect(result).to eq(21)  # VAT rate for Spain
      end
    end

    context 'when the buyer is in the EU and is a company' do
      it 'applies 0 tax' do
        transaction = Transaction.new("FR", :buyer_is_company, "FR", :digital_service)

        result = digital_service_tax_strategy.calculate(transaction, vat_service)

        expect(result).to eq(0)  # No tax for EU companies
      end
    end

    context 'when the buyer is in the EU and is an individual' do
      it 'fetches the tax rate for the buyer’s country' do
        transaction = Transaction.new("FR", :buyer_is_individual, "FR", :digital_service)
        
        result = digital_service_tax_strategy.calculate(transaction, vat_service)
        
        expect(result).to eq(20)  # VAT rate for France
      end
    end

    context 'when the buyer is outside the EU' do
      it 'applies 0 tax' do
        transaction = Transaction.new("US", :buyer_is_individual, "US", :digital_service)

        result = digital_service_tax_strategy.calculate(transaction, vat_service)

        expect(result).to eq(0)  # No tax for non-EU countries
      end
    end
  end
end
