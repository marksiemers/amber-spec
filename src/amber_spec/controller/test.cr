abstract class Spec::ControllerTestCase
  MODIFYING_HTTP_VERBS = %w(get head post put patch delete)
  HTTP_VERBS           = %w(get head)

  macro inherited

	# Content type should be set for request that have body
	# get requests do not have body so no need to have content type header
    {% for method in MODIFYING_HTTP_VERBS %}
    def {{method.id}}(path, headers : HTTP::Headers? = nil, body : String? = nil)
      request = HTTP::Request.new("{{method.id}}".upcase, path, headers, body )
      unless HTTP_VERBS.includes? method
        request.headers["Content-Type"] = "application/x-www-form-urlencoded"
      end
      Request.response = process_request request
    end
    {% end %}

    def response
      Request.response.not_nil!
    end

    private def process_request(request)
      io = IO::Memory.new
      response = HTTP::Server::Response.new(io)
      context = HTTP::Server::Context.new(request, response)
      main_handler = build_main_handler
      main_handler.call context
      response.close
      io.rewind
      client_response = HTTP::Client::Response.from_io(io, decompress: false)
      Request.response = client_response
    end

    private def build_main_handler
      handler = Amber::Server.settings.handler
      handler.prepare_pipelines
      handler
    end
  end
end
