require './register.rb'
require './discount.rb'

class Bill
  attr_accessor :id, :products, :errors

  @@bill = {}
  def initialize(params)
    @id = params[:customer]
    self.products = {}
    create_or_update_bill(params)
  end

  def create_or_update_bill(params)
    bill = @@bill[[self.id]]
    bill = @@bill[[self.id]] = self unless bill
    item = bill.products[params[:index]] ||= {}
    product_code = params[:product_code]
    @errors = []
    disc_code = params[:discount]
    if product_code
      product = Register.get_product_details_by_code(product_code)
      if product
        quantity = params[:quantity].to_f
        if quantity <= product[:quantity].to_f
          product[:quantity] = product[:quantity] - quantity unless disc_code
          item[:name] = product[:name]
          item[:price] = product[:price]
          item[:quantity] = quantity
        else
          @errors.push("The quantity is not available")
        end
      else
        @errors.push('Invalid product code')
      end
    end

    if disc_code && !disc_code.empty?
      discount = Discount.get_discount_details_by_code(disc_code)
      if discount
        item[:discount] = discount.percentage
      else
        @errors.push('Wrong discount code')
      end
    end
    @errors
  end

  def self.get_details(id)
    bill = @@bill[[id]]
    puts "Customer: #{bill.id}"
    puts 'Name   quantity   price   total discount'
    grand_total = 0
    bill.products.each do |key, value|
      next unless value[:name]
      quantity = value[:quantity].to_f
      price = value[:price].to_f
      total = quantity * price
      discout = value[:discount].to_f / 100
      discount_amount = total * discout
      puts "#{value[:name].ljust(8)} #{quantity.to_s.ljust(8)} #{price.to_s.ljust(8)} #{total.to_s.ljust(8)} #{discount_amount.to_s.ljust(12)}"
      grand_total += total - discount_amount
    end
    puts "Total: #{grand_total}"
  end
end
