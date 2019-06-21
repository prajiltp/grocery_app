require './helper'
class Register
  attr_accessor :id, :products, :name

  @@register = {}

  def initialize(params)
    @id = params[:id]
    @name = Helper.case_insentive(params['register name'])
    @products = params[:products]
    self.products = {}
    create_or_find_register(params)
  end

  def create_or_find_register(params)
    register = @@register[self.name]
    register = @@register[self.name] = self unless register 
    assign_product_and_price(register, params)
  end

  def assign_product_and_price(register, params)
    product = Helper.case_insentive(params['product code'])
    product = register.products[[product]] ||= {}
    create_or_update_product_details(product, params)  
  end

  def create_or_update_product_details(product, params)
    price = Helper.case_insentive(params['price'])
    quantity = Helper.case_insentive(params['quantity'])
    product_name = Helper.case_insentive(params['product name'])
    product[:name] = product_name
    product[:price] = price
    product[:quantity] ||= 0
    product[:quantity] += quantity.to_f
  end

  def case_insentive(value)
    return "" if value.nil?
    value.downcase.strip
  end
  
  class << self
    def get_product_details_by_code(code)
      product = @@register.detect {|key, value| value.products.keys.flatten.include? code}
      product[1].products[[code]] if product and product[1].products
    end

     def get_list
        pr_code = "Product code."
        pr_name = "Product Name."
        puts "#{pr_code.ljust(10)} #{pr_name.ljust(15)} Quantity Price"
        @@register.each do |key, value|
          next unless value.products
          value.products.each do |key2, product|
            puts "#{key2[0].to_s.ljust(12)} #{product[:name].ljust(15)} #{product[:quantity].to_s.ljust(12)}  #{product[:price]}" 
          end
        end
      end
    end
end
