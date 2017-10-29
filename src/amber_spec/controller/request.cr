module AmberSpec::Controller
  class Request
    @@response : HTTP::Client::Response?

    def self.response=(@@response)
    end

    def self.response
      @@response
    end
  end
end
