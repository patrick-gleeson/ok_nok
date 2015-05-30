module OkNok
  module ObjectExtensions
    def ok(value)
      OkNok::Returnable.new(OkNok::OK, value)
    end
    
    def nok(value)
      OkNok::Returnable.new(OkNok::NOK, value)
    end
  end
end
