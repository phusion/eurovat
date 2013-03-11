# Utility library for handling European Union VAT numbers

This library aids in checking whether one should charge a customer Value Added Tax (based on your and his country information and whether he has provided a VAT number) and in checking whether a VAT number is correct. It uses the European Union's VAT number checking SOAP service.

On Ruby 1.8, it uses the builtin SOAP library. On Ruby 1.9, it requires the `savon` gem. We do not specify Savon as a dependency so you'll have to do it yourself.

When using Rails, add this to your Gemfile:

    gem 'eurovat'
    gem 'savon', :platforms => :ruby_19

## Cryptographic verification

Our gem is signed using PGP with the [Phusion Software Signing key](http://www.phusion.nl/about/gpg). That key in turn is signed by [the rubygems-openpgp Certificate Authority](http://www.rubygems-openpgp-ca.org/).

You can verify the authenticity of the gem by following [The Complete Guide to Verifying Gems with rubygems-openpgp](http://www.rubygems-openpgp-ca.org/blog/the-complete-guide-to-verifying-gems-with-rubygems-openpgp.html).

## Usage

Setup your company's own country first. This value defaults to 'Netherlands'. It assumes that your own country is a country within the European Union. We currently do not support businesses that are located outside the EU but for some reason still need to work with EU VAT.

    Eurovat.country = 'Netherlands'

`Eurovat.must_charge_vat(customer_country, vat_number)` is used for checking whether you need to charge a customer VAT, according to the Dutch VAT rules. I do not know whether these rules apply only to the Netherlands or to the entire EU, so you should do your research before using this function. This function also does not take care of exceptions to the rule, e.g. conferences that are organized within the EU (for which VAT must always be charged no matter what).

    # Customer is from United States and didn't supply a VAT number. Must we charge VAT?
    Eurovat.must_charge_vat?('United States', nil)   => false

    # Customer is a consumer from the Netherlands (no VAT number). Must we charge VAT?
    Eurovat.must_charge_vat?('Netherlands', nil)     => true
    
    # Customer is a business from the Netherlands. Must we charge VAT?
    Eurovat.must_charge_vat?('Netherlands', 'NL8192.25.642.B01')   => false

    # Customer is a business outside one's country, but inside the EU. Must we charge VAT?
    Eurovat.must_charge_vat?('Germany', 'some valid German VAT number')   => false

Use `Eurovat#check_vat_number` to check whether a VAT number is correct. This method contacts the [European Union VAT checking service](http://ec.europa.eu/taxation_customs/vies/) and returns true if the VAT number is valid and false if it isn't. If the VAT number doesn't even look like one, then it will raise `Eurovat::InvalidFormatError`. Any exception other than `Eurovat::InvalidFormatError` indicates that the service is down.

    eurovat = Eurovat.new
    eurovat.check_vat_number('NL819225642B01')   => true
    eurovat.check_vat_number('NL010101010B99')   => false
    # It automatically strips away spaces and dots:
    eurovat.check_vat_number('NL8192.25.642.B01')   => true

## About the EU VAT checking service's uptime

Experience has shown that the EU VAT checking service's uptime really sucks. While organizing [BubbleConf](http://www.bubbleconf.com/) we've experienced multiple outages that lasted for hours, if not days, which affected sales and attendee satisfaction. Even though we are required by law to check for the validity of the VAT number, I strongly recommend you not to reject business transactions when the EU VAT checker is down, like we did at first. Instead, silently accept their VAT number but put a flag on it, and check these VAT numbers *later* when the EU VAT checking service is up again.

## Other notes

Eurovat is completely thread-safe. That said, for optimal performance you should use one Eurovat object instance per thread.