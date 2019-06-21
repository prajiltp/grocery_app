require './helper'
require 'pry'
class Discount
  attr_accessor :id, :code, :percentage, :percentage, :description

  @@discount = {}

  def initialize(params)
    @id = params[:id]
    @code = Helper.case_insentive(params['code'])
    create_or_find_discount(params)
  end

  def create_or_find_discount(params)
    discount = @@discount[self.code]
    discount = @@discount[self.code] = self unless discount
    discount.percentage = params['percentage']
    discount.description = params['description']
  end

  class << self
    def get_discount_details_by_code(code)
      discount = @@discount.detect {|key,value| key == code}
      discount[1] if discount
    end

    def get_list
      dis_code = "Discount code."
      dis_name = "Discount description."
      puts "#{dis_code.ljust(12)} #{dis_name.ljust(15)} Percentage"
      @@discount.each do |key, value|
        puts "#{key.to_s.ljust(14)} #{value.description.ljust(18)} #{value.percentage.to_s.ljust(12)}" 
      end
    end
  end
end
