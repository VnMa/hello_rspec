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
    # Calculate total based on promotional rules
  end


  def total
    products_count = Hash.new
    products_map = Hash.new
    rules = @promotional_rules
    
    @products.each do |p|
      code = p.product_code
      prd = products_count[code]
      products_count[code] = prd.nil? ? 1 : (prd + 1)
      products_map[code] = p
    end

    total = 0
    products_map.each do |code, product|
      count = products_count[code]
      pprice = calculate_product_price(product, count, rules)
      total += (pprice  * count.to_i)
    end

    calculate_total_discount(total, rules).round(2)
  end

  private 
  def calculate_product_price(product, quantity, rules)
    price = product.price 
    product_promotion = PromotionalRule.product_quantity_applied(rules, product, quantity)
    
    # Apply rule
    unless product_promotion.nil?
      return product_promotion.rule[:price]
    end
    return price
  end

  def calculate_total_discount(total, rules)
    product_promotion = PromotionalRule.total_price_applied(rules, total)
    product_promotion.nil? ? total : (total * (100 - product_promotion.rule[:discount]) / 100)
  end 
end