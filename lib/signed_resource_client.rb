require 'ezcrypto'

module SignedResource

  VERSION = '1.0'

  module Base
    def connection(refresh = false)
      @connection = SignedResource::Connection.new(site) if refresh || @connection.nil?
      @connection
    end
    def self.random_string(length = 8)
      chars = ("a".."z").to_a + ("0".."9").to_a + ("A".."Z").to_a
      Array.new(length, '').collect{chars[rand(chars.size)]}.join 
    end
  end

  class Connection < ActiveResource::Connection
    cattr_accessor :api_key
    cattr_accessor :api_secret


    protected

      def sign_url(path)
        uri = URI.parse(path)
        uri.query = (uri.query.nil? ? '' : "#{uri.query}&") << "ts=#{Time.now.to_i}&rnd=#{SignedResource::Base.random_string(16)}&key=#{api_key}"
        hash = Digest::SHA1.hexdigest("#{uri.query}#{api_secret}")
        uri.query << "&sig=#{hash}"
        uri.to_s
      end


    private

      def build_request_headers(*args)
        { 'X-Signed-Resource' => SignedResource::VERSION }.update(super(*args))
      end

      def request(method, path, *arguments)
        raise StandardError.new('must set api_key') unless api_key
        raise StandardError.new('must set api_secret') unless api_secret

        path = sign_url(path)

        case method
          when :put, :post  # need to encrypt the body
            body = arguments.shift
            @key = EzCrypto::Key.with_password(api_key, api_secret)
            body = @key.encrypt64(body)
            arguments.unshift(body)
        end

        logger.info "#{method.to_s.upcase} #{site.scheme}://#{site.host}:#{site.port}#{path}" if logger
        result = nil
        time = Benchmark.realtime { result = http.send(method, path, *arguments) }
        logger.info "--> #{result.code} #{result.message} (#{result.body.length}b %.2fs)" % time if logger
        key = EzCrypto::Key.with_password(api_key, api_secret)
        result.instance_eval "@body = #{key.decrypt64(result.body).inspect}" # @body is protected
        handle_response(result)
      end
  end
end

ActiveResource::Base.class_eval do
  def self.requires_signage
    self.extend(SignedResource::Base)
  end
end
