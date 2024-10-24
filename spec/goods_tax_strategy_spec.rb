require_relative '../goods_tax_strategy'

RSpec.describe GoodsTaxStrategy do
  let(:vat_service) { double("VATService") }
  let(:transaction) { double("Transaction") }
  let(:goods_tax_strategy) { GoodsTaxStrategy.new }

  describe '#calculate' do
    context 'when buyer is in Spain' do
      it 'fetches the tax rate for Spain' do
        allow(transaction).to receive(:buyer_in_spain?).and_return(true)
        allow(vat_service).to receive(:fetch_rate).with("ES").and_return(21)

        result = goods_tax_strategy.calculate(transaction, vat_service)
        
        expect(result).to eq(21)
      end
    end

    context 'when buyer is in the EU and is a company' do
      it 'applies 0 tax' do
        allow(transaction).to receive(:buyer_in_spain?).and_return(false)
        allow(transaction).to receive(:buyer_in_eu?).and_return(true)
        allow(transaction).to receive(:buyer_is_company?).and_return(true)

        result = goods_tax_strategy.calculate(transaction, vat_service)

        expect(result).to eq(0)
      end
    end

    context 'when buyer is in the EU and is not a company' do
      it 'fetches the tax rate for the buyer’s country' do
        allow(transaction).to receive(:buyer_in_spain?).and_return(false)
        allow(transaction).to receive(:buyer_in_eu?).and_return(true)
        allow(transaction).to receive(:buyer_is_company?).and_return(false)
        allow(transaction).to receive(:buyer_country).and_return("FR")
        allow(vat_service).to receive(:fetch_rate).with("FR").and_return(20)

        result = goods_tax_strategy.calculate(transaction, vat_service)

        expect(result).to eq(20)
      end
    end

    context 'when buyer is outside the EU' do
      it 'applies 0 tax' do
        allow(transaction).to receive(:buyer_in_spain?).and_return(false)
        allow(transaction).to receive(:buyer_in_eu?).and_return(false)

        result = goods_tax_strategy.calculate(transaction, vat_service)

        expect(result).to eq(0)
      end
    end
  end
end
