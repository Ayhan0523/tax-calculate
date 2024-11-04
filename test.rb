require_relative 'vat_service'
require_relative 'tax_calculator'
require_relative 'transaction'

vat_service = VatService.new
calculator = TaxCalculator.new(vat_service)

t1 = Transaction.new('ES', :buyer_is_company, 'ES', :physical)
t2 = Transaction.new('DE', :buyer_is_company, 'ES', :physical)
t3 = Transaction.new('DE', :buyer_is_individual, 'ES', :physical)
t4 = Transaction.new('US', :buyer_is_individual, 'ES', :physical)
pp calculator.calculate_tax(t1)
pp calculator.calculate_tax(t2)
pp calculator.calculate_tax(t3)
pp calculator.calculate_tax(t4)
