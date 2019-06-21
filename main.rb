require './import_csv_util.rb'
require './bill.rb'

ImportCsvUtil.parse_store_data_csv('./register_data.csv')
ImportCsvUtil.parse_discount_coupon('./discount_data.csv')

def update_or_create_bill(params)
  bill = Bill.new(params)
  @errors = bill.errors
  if @errors
    puts @errors
    continue = 'y'
  end
end

def apply_discount(params)
  Discount.get_list
  puts 'Apply promo code'
  params[:discount] = gets.chomp
  update_or_create_bill(params)
end

def set_product_data(params)
  Register.get_list
  puts 'Choose the product and eneter the code'
  params[:product_code] = gets.chomp
  puts 'Enter the quantiy in KG'
  params[:quantity] = gets.chomp
  update_or_create_bill(params)
  params
end

def customer_entry()
  @errors = []
  continue = 'y'
  params = {}
  index = 1
  puts 'Customer name'
  customer = gets.chomp
  while (continue == 'y')
    params[:index] = index
    params[:customer] = customer
    params = set_product_data(params)
    apply_discount(params)
    puts 'continue? y : any other key'
    continue = gets.chomp
    params = {}
    index += 1
  end
  puts 'Bill details'
  Bill.get_details(customer)

  puts "\n \n \n \n"

  puts 'Store details'

  Register.get_list
end
answer = 'y'
while (answer == 'y')
  customer_entry()
  puts "Have new purchace? y or any other key to exit"
  answer = gets.chomp
end