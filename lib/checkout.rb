require 'product'
require 'promotional_rule'

class Checkout
  attr_reader :products
  attr_reader :promotional_rules

  def initialize(promotional_rules)
    @products = []
    @promotional_rules = promotional_rules
  end

  def scan(product_code)
    @products.push(Product.get(product_code))
  end

  def total
    rules = @promotional_rules
    total = 0
    count_products(@products).each do |_, product_w_count|
      count = product_w_count[:quantity]
      pprice = calculate_product_price(product_w_count, rules)
      total += (pprice  * count.to_i)
    end

    calculate_total_discount(total, rules).round(2)
  end

  private 
  def count_products(products)
    products.reduce(Hash.new) do |acc, p|
      code = p.product_code
      count = acc[code].nil? ? 1 : acc[code][:quantity].to_i + 1
      prd = p.to_json.merge(quantity: count)
      acc.merge(Hash[code, prd])
    end
  end

  def calculate_product_price(product, rules)
    price = product[:price]
    quantity = product[:quantity]
    product_promotion = PromotionalRule.product_quantity_applied(rules, product, quantity)
    product_promotion.nil? ? price : product_promotion.rule[:price]
  end

  def calculate_total_discount(total, rules)
    product_promotion = PromotionalRule.total_price_applied(rules, total)
    product_promotion.nil? ? total : (total * (100 - product_promotion.rule[:discount]) / 100)
  end 
end