require_relative '../Strategy/onsite_service_tax_strategy'
require_relative '../Strategy/tax_strategy'

RSpec.describe OnsiteServiceTaxStrategy do
  let(:vat_service) { double("VATService") }
  let(:service) { double("Service") }
  let(:transaction) { double("Transaction", service: service) }
  let(:onsite_service_tax_strategy) { OnsiteServiceTaxStrategy.new }

  describe '#calculate' do
    context 'when the service is located in Spain' do
      it 'fetches the tax rate for Spain' do
        allow(service).to receive(:service_in_spain?).and_return(true)
        allow(vat_service).to receive(:fetch_rate).with("ES").and_return(21)

        result = onsite_service_tax_strategy.calculate(transaction, vat_service)

        expect(result).to eq(21)
      end
    end

    context 'when the service is located outside Spain' do
      it 'applies 0 tax' do
        allow(service).to receive(:service_in_spain?).and_return(false)

        result = onsite_service_tax_strategy.calculate(transaction, vat_service)

        expect(result).to eq(0)
      end
    end

    context 'when calling `calculate` on the base TaxStrategy' do
      it 'raises NotImplementedError' do
        tax_strategy = TaxStrategy.new

        expect { tax_strategy.calculate(transaction, vat_service) }
          .to raise_error(NotImplementedError, "Subclasses must implement the `calculate` method.")
      end
    end
  end
end