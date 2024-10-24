require_relative '../Strategy/tax_strategy'
require_relative '../Strategy/onsite_service_tax_strategy'
require_relative '../Strategy/digital_service_tax_strategy'
require_relative '../Strategy/goods_tax_strategy'
require_relative '../tax_calculator'
require_relative '../transaction'
require_relative '../vat_service'

# Define the tests for the Tax Calculation system
RSpec.describe 'Tax Calculation System' do
  let(:vat_service) { VatService.new }

  describe 'GoodsTaxStrategy' do
    let(:goods_tax_strategy) { GoodsTaxStrategy.new }
    let(:tax_calculator) { TaxCalculator.new(goods_tax_strategy, vat_service) }

    context 'when the buyer is in Spain' do
      it 'applies the VAT rate for Spain' do
        transaction = Transaction.new("ES", :buyer_is_individual, "ES", :goods)
        result = tax_calculator.calculate_tax(transaction)
        expect(result).to eq(21)  # Spanish VAT rate is 21%
      end
    end

    context 'when the buyer is in the EU and is a company' do
      it 'applies 0 tax for EU companies' do
        transaction = Transaction.new("FR", :buyer_is_company, "FR", :goods)
        result = tax_calculator.calculate_tax(transaction)
        expect(result).to eq(0)  # No VAT for EU companies
      end
    end

    context 'when the buyer is in the EU and is an individual' do
      it 'applies the VAT rate for the buyer’s country' do
        transaction = Transaction.new("FR", :buyer_is_individual, "FR", :goods)
        result = tax_calculator.calculate_tax(transaction)
        expect(result).to eq(20)  # French VAT rate is 20%
      end
    end

    context 'when the buyer is outside the EU' do
      it 'applies 0 tax for non-EU buyers' do
        transaction = Transaction.new("US", :buyer_is_individual, "US", :goods)
        result = tax_calculator.calculate_tax(transaction)
        expect(result).to eq(0)  # No tax for non-EU countries
      end
    end
  end

  describe 'OnsiteServiceTaxStrategy' do
    let(:onsite_service_tax_strategy) { OnsiteServiceTaxStrategy.new }
    let(:tax_calculator) { TaxCalculator.new(onsite_service_tax_strategy, vat_service) }
    
    let(:service) { double("Service") }
    let(:transaction) { double("Transaction", service: service) }

    context 'when the service is located in Spain' do
      it 'applies the VAT rate for Spain' do
        allow(service).to receive(:service_in_spain?).and_return(true)
        result = tax_calculator.calculate_tax(transaction)
        expect(result).to eq(21)  # Spanish VAT rate is 21%
      end
    end

    context 'when the service is located outside Spain' do
      it 'applies 0 tax for services outside Spain' do
        allow(service).to receive(:service_in_spain?).and_return(false)
        result = tax_calculator.calculate_tax(transaction)
        expect(result).to eq(0)  # No tax outside Spain
      end
    end
  end

  describe 'DigitalServiceTaxStrategy' do
    let(:digital_service_tax_strategy) { DigitalServiceTaxStrategy.new }
    let(:tax_calculator) { TaxCalculator.new(digital_service_tax_strategy, vat_service) }

    context 'when the buyer is in Spain' do
      it 'applies the VAT rate for Spain' do
        transaction = Transaction.new("ES", :buyer_is_individual, "ES", :digital_service)
        result = tax_calculator.calculate_tax(transaction)
        expect(result).to eq(21)  # Spanish VAT rate is 21%
      end
    end

    context 'when the buyer is in the EU and is a company' do
      it 'applies 0 tax for EU companies' do
        transaction = Transaction.new("FR", :buyer_is_company, "FR", :digital_service)
        result = tax_calculator.calculate_tax(transaction)
        expect(result).to eq(0)  # No VAT for EU companies
      end
    end

    context 'when the buyer is in the EU and is an individual' do
      it 'applies the VAT rate for the buyer’s country' do
        transaction = Transaction.new("FR", :buyer_is_individual, "FR", :digital_service)
        result = tax_calculator.calculate_tax(transaction)
        expect(result).to eq(20)  # French VAT rate is 20%
      end
    end

    context 'when the buyer is outside the EU' do
      it 'applies 0 tax for non-EU buyers' do
        transaction = Transaction.new("US", :buyer_is_individual, "US", :digital_service)
        result = tax_calculator.calculate_tax(transaction)
        expect(result).to eq(0)  # No tax for non-EU countries
      end
    end
  end
end
