class Helper
  def self.case_insentive(value)
    return "" if value.nil?
    value.downcase.strip
  end
end
