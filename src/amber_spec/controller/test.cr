require "./request"
require "http/server"
require "amber"

abstract class Spec::ControllerTestCase
  include AmberSpec::Controller
  macro inherited

    {% http_read_verbs  = %w(get head) %}
    {% http_write_verbs = %w(post put patch delete) %}
    {% http_verbs       = http_read_verbs + http_write_verbs %}

  	# Content type should be set for request that have body
  	# get requests do not have body so no need to have content type header
    {% for method in http_verbs %}
      def {{method.id}}(path, headers : HTTP::Headers? = nil, body : String? = nil)
        request = HTTP::Request.new("{{method.id}}".upcase, path, headers, body )
        {% if http_write_verbs.includes? method %}
          request.headers["Content-Type"] = "application/x-www-form-urlencoded"
        {% end %}
        Request.response = process_request request
      end
    {% end %}

  end

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
