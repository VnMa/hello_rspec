require 'product'
require 'checkout'
require 'promotional_rule'

RSpec.describe Checkout do
    it "should not discount with no promotion" do
      product_codes = [
        '001', '002', '003'
      ]
      checkout =  Checkout.new([])
      product_codes.each{|code| checkout.scan(code)}

      expect(checkout.total).to eq 74.2
    end

		it "should discount 10% for checkout with total price > 60 pound" do
      product_codes = [
        '001', '002', '003'
      ]
      checkout =  Checkout.new(PromotionalRule.sample)
      product_codes.each{|code| checkout.scan(code)}

      expect(checkout.total).to eq 66.78
    end

    it "should apply lower price for Lavender product ( quantity >= 2) (8.5 pound)" do
      product_codes = [
        '001', '003', '001'
      ]
      checkout = Checkout.new(PromotionalRule.sample)
      product_codes.each{|code| checkout.scan(code)}

      expect(checkout.total).to eq 36.95
    end

    it "should apply lower price for Lavender product (8.5 pound) and discount 10% for total price > 60 pound" do
      product_codes = [
        '001', '002', '001', '003'
      ]
      checkout = Checkout.new(PromotionalRule.sample)
      product_codes.each{|code| checkout.scan(code)}

      expect(checkout.total).to eq 73.76
		end
end