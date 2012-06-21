# Utility library for handling European Union VAT numbers

This library aids in checking whether one should charge a customer Value Added Tax (based on your and his country information and whether he has provided a VAT number) and in checking whether a VAT number is correct. It uses the European Union's VAT number checking SOAP service.

On Ruby 1.8, it uses the builtin SOAP library. On Ruby 1.9, it requires the `savon` gem. We do not specify Savon as a dependency so you'll have to do it yourself.

When using Rails, add this to your Gemfile:

    gem 'eurovat'
    gem 'savon', :platforms => :ruby_19

## Usage

Setup your company's own country first. This value defaults to 'Netherlands'. It assumes that your own country is a country within the European Union. We currently do not support businesses that are located outside the EU but for some reason still need to work with EU VAT.

    Eurovat.country = 'Netherlands'

`Eurovat.must_charge_vat(customer_country, vat_number)` is used for checking whether you need to charge a customer VAT.

    # Customer is from United States and didn't supply a VAT number. Must we charge VAT?
    Eurovat.must_charge_vat?('United States', nil)   => false

    # Customer is a consumer from the Netherlands (no VAT number). Must we charge VAT?
    Eurovat.must_charge_vat?('Netherlands', nil)     => true
    
    # Customer is a business from the Netherlands. Must we charge VAT?
    Eurovat.must_charge_vat?('Netherlands', 'NL8192.25.642.B01')   => false

    # Customer is a business outside one's country, but inside the EU. Must we charge VAT?
    Eurovat.must_charge_vat?('Germany', 'some valid German VAT number')   => false

Use `Eurovat#check_vat_number` to check whether a VAT number is correct. This method contacts the European Union VAT checking service and returns true if the VAT number is valid and false if it isn't. If the VAT number doesn't even look like one, then it will raise `Eurovat::InvalidFormatError`.

    eurovat = Eurovat.new
    eurovat.check_vat_number('NL819225642B01')   => true
    eurovat.check_vat_number('NL010101010B99')   => false
    # It automatically strips away spaces and dots:
    eurovat.check_vat_number('NL8192.25.642.B01')   => true

## Other notes

Eurovat is completely thread-safe. That said, for optimal performance you should use one Eurovat object instance per thread.