class Product
    attr_reader :product_code
    attr_reader :name
    attr_reader :price

    def initialize(product_code, name, price)
        @product_code = product_code
        @name = name
        @price = price
    end
    
    def self.product_list
        Hash[
            '001' => Product.new('001', 'Lavender heart', 9.25),
            '002' => Product.new('002', 'Personalised cufflinks', 45.00),
            '003' => Product.new('003', 'Kids T-shirt', 19.95)
        ]
    end

    def self.get(product_code) 
        product_list[product_code]
    end
end