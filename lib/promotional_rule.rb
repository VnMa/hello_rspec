class PromotionalRule
  attr_reader :type
  attr_reader :rule

  def initialize(type, rule)
    @type = type
    @rule = rule
  end

  def self.sample
    [
      PromotionalRule.new('total_price', {
        min_price: 60,
        discount: 10
      }),
      PromotionalRule.new('product_quantity', {
        product_code: '001',
        min_quantiy: 2,
        price: 8.5
      })
    ]
  end

  def self.total_price_applied(rules, total)
    rules.select{|r| (r.type == 'total_price' && r.rule[:min_price].to_i <= total.to_i) }.first
  end

  def self.product_quantity_applied(rules, product, quantity)
    rules.select do |r| 
      r.type == 'product_quantity' && r.rule[:product_code] == product[:product_code] && r.rule[:min_quantiy].to_i <= quantity
    end.first
  end

  def to_s
    "type: #{@type}; rule: #{@rule}"
  end
end