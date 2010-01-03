require 'bertrpc'
require 'logger'
require 'eventmachine'

module BERTREM
  # NOTE: ernie closes connections after responding, so we can't send
  #       multiple requests per connection.  Hence, the default for
  #       persistent is false.  If you are working with a server that
  #       supports more than one request per connection, like
  #       BERTREM::Server, call BERTREM.service with persistent = true
  #       and it will Just Work.
  class Client < EventMachine::Connection
    include BERTRPC::Encodes

    attr_accessor :requests

    class Request
      attr_accessor :kind, :options

      def initialize(svc, kind, options)
        @svc = svc
        @kind = kind
        @options = options
      end

      def method_missing(cmd, *args)
        BERTRPC::Mod.new(@svc, self, cmd)
      end

    end

    class << self
      attr_accessor :persistent
    end

    self.persistent = false

    def self.service(host, port, persistent = false, timeout = nil)
      self.persistent = persistent
      c = EM.connect(host, port, self)
      c.pending_connect_timeout = timeout if timeout
      c
    end

    def post_init
      @requests = []
      @receive_buf = ""
    end

    def unbind
      super
      @receive_buf = ""
      (@requests || []).each {|r| r.fail}
      raise BERTREM::ConnectionError.new("Connection to server lost!") if error?
    end

    def persistent
      Client.persistent
    end

    def receive_data(bert_response)
      @receive_buf << bert_response
      while @receive_buf.length > 4 do
        begin
          raise BERTRPC::ProtocolError.new(BERTRPC::ProtocolError::NO_HEADER) unless @receive_buf.length > 4
          len = @receive_buf.slice!(0..3).unpack('N').first
          raise BERTRPC::ProtocolError.new(BERTRPC::ProtocolError::NO_DATA) unless @receive_buf.length > 0
        rescue Exception => e
          log "Bad BERT message: #{e.message}"          
        end

        bert = @receive_buf.slice!(0..(len - 1))
        @requests.pop.succeed(decode_bert_response(bert))  
        break unless persistent
      end
      close_connection unless persistent
    end

    def call(options = nil)
      verify_options(options)
      Request.new(self, :call, options)
    end

    def cast(options = nil)
      verify_options(options)
      Request.new(self, :cast, options)
    end

    def verify_options(options)
      if options
        if cache = options[:cache]
          unless cache[0] == :validation && cache[1].is_a?(String)
            raise BERTRPC::InvalidOption.new("Valid :cache args are [:validation, String]")
          end
        else
          raise BERTRPC::InvalidOption.new("Valid options are :cache")
        end
      end
    end

  end

end

class BERTREM::ConnectionError < StandardError ; end