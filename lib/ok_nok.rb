require "ok_nok/version"
require "ok_nok/statuses"
require "ok_nok/returnable"

module OkNok
  def ok(value)
    OkNok::Returnable.new(OkNok::OK, value)
  end
  
  def nok(value)
    OkNok::Returnable.new(OkNok::NOK, value)
  end
  
  def self.nok_if(comparison_value, nok_value)
    raise ArgumentError, "You must provide a block" unless block_given?
    block_result = yield
    if block_result == comparison_value
      nok nok_value
    else
      ok block_result
    end
  end
  
  def self.nok_if_exception(nok_value)
    raise ArgumentError, "You must provide a block" unless block_given?
    begin
      ok yield
    rescue StandardError
      nok nok_value
    end
  end
end
