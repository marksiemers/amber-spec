abstract class Spec::ControllerTestCase
  MODIFYING_HTTP_VERBS = %w(post put patch)
  HTTP_VERBS           = %w(get head delete)

  macro inherited

	# Content type should be set for request that have body
	# get requests do not have body so no need to have content type header
    {% for method in MODIFYING_HTTP_VERBS %}
    def {{method.id}}(path, headers : HTTP::Headers? = nil, body : String? = nil)
      request = HTTP::Request.new("{{method.id}}".upcase, path, headers, body )
      request.headers["Content-Type"] = "application/x-www-form-urlencoded"
      Request.response = process_request request
    end
    {% end %}

    {% for method in HTTP_VERBS %}
    def {{method.id}}(path, headers : HTTP::Headers? = nil, body : String? = nil)
      request = HTTP::Request.new("{{method.id}}".upcase, path, headers, body )
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
