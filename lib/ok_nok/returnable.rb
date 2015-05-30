module OkNok
  class Returnable
    attr_reader :status, :value
    
    def initialize(status, value)
      raise ArgumentError, "Status must be OkNok::OK or OkNok::NOK" unless [OkNok::OK, OkNok::NOK].include? status
      @status, @value = status, value
    end
    
    def ok?
      @status == OkNok::OK
    end
    
    def nok?
      @status == OkNok::NOK
    end
    
    def value_or_if_nok
      return value if ok?
      return nil unless block_given?
      yield value
    end
    
    def value_or_if_ok
      return value if nok?
      return nil unless block_given?
      yield value
    end
    
    def ok
      if ok?
        yield value if block_given?
      end
      return self
    end
    
    def nok
      if nok?
        yield value if block_given?
      end
      return self
    end
  end
end
