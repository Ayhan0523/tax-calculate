class VatService
	def fetch_rate(country)
		vat_rates = {
			"ES" => 21,
			"FR" => 20,
			"DE" => 19,
			"IT" => 22
		}
		vat_rates[country] || 0
	end
end
	