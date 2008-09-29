module LittleTranslator
  class Base
    def self.logger
      @@logger ||= returning(Logger.new(STDOUT)) do |logger|
        logger.level = Logger::INFO
      end
    end

    def self.site=(new_site)
      Sender.site = new_site
      Receiver.site = new_site
    end

    def self.api_key=(key)
      SignedResource::Connection.api_key = key
    end

    def self.api_secret=(secret)
      SignedResource::Connection.api_secret = secret
    end
  end
end
