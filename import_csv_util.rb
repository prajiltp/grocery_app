require 'csv'
require './register.rb'
require './discount.rb'

class ImportCsvUtil
  class << self
    def parse_store_data_csv(file)
      parsed_csv = parse_csv_file(file)
      parsed_csv.each do |row|
        Register.new(row.to_hash)
      end
    end

    def parse_discount_coupon(file)
      parsed_csv = parse_csv_file(file)
      parsed_csv.each do |row|
        Discount.new(row.to_hash)
      end
    end

    def parse_csv_file(file)
      csv_text = File.read(file)
      CSV.parse(csv_text, headers: true)
    end
  end
end