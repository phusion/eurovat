$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))
require 'rubygems'
require 'eurovat'

describe Eurovat do
  # NL819225642B01 is Phusion's VAT number. If we ever go out of business replace
  # it with any other valid VAT number to have the unit tests pass.

  it "works" do
    @eurovat = Eurovat.new
    @eurovat.check_vat_number('FI20584306').should be_truthy
    @eurovat.check_vat_number('NL010101010B99').should be_falsey
  end

  it "strips away spaces and dots" do
    @eurovat = Eurovat.new
    @eurovat.check_vat_number('FI 2058.4306').should be_truthy
  end

  it "raises InvalidFormatError if the VAT number is not formatted like one" do
    @eurovat = Eurovat.new
    lambda { @eurovat.check_vat_number('foobar') }.should raise_error(Eurovat::InvalidFormatError)
    lambda { @eurovat.check_vat_number('foobar!') }.should raise_error(Eurovat::InvalidFormatError)
  end

  it "always charges VAT if the customer is from one's own country" do
    Eurovat.must_charge_vat?('Netherlands', nil).should be_truthy
    Eurovat.must_charge_vat?('Netherlands', 'NL819225642B01').should be_truthy
  end

  it "doesn't charge VAT if the customer is outside one's own country and supplied a VAT number" do
    Eurovat.must_charge_vat?('Germany', 'NL819225642B01').should be_falsey
    Eurovat.must_charge_vat?('United States', 'NL819225642B01').should be_falsey
  end

  it "charges VAT if the customer is outside one's own country, but inside the EU, and didn't supply a VAT number" do
    Eurovat.must_charge_vat?('Germany', nil).should be_truthy
  end

  it "doesn't charge VAT if the customer is outside one's own country, outside the EU, and didn't supply a VAT number" do
    Eurovat.must_charge_vat?('United States', nil).should be_falsey
  end
end
