module LittleTranslator

  class Connection < ActiveResource::Base
    self.site = 'http://localhost:3000/api/v1/'
    self.format = :json
    requires_signage

    def self.options_query
      hash = {}
      hash[:force] = 1 if ENV['FORCE']
      {:options => hash}.to_query
    end

    def self.locale
      @@locale ||= self.get("#{self.prefix}locale.json")['response']['message']
    end

    def self.sync!(translations)
      response = self.post("#{self.prefix}sync.json?#{self.options_query}", {:translations => translations[self.locale]}.to_json)
      ActiveSupport::JSON.decode(response.body)['response']['translations']
    end

    protected

      def self.get(*args)
        protect { self.connection.get(*args) }
      end

      def self.post(*args)
        protect { self.connection.post(*args) }
      end

      def self.protect(&block)
        begin
          yield
          rescue ActiveResource::ConnectionError => e
            error = ActiveSupport::JSON.decode(e.response.body)['response']
            puts "ERROR: #{error['message']}"
            exit
          rescue => e
            puts "An unknown error occured.  Please try again later."
            puts "\t#{e.class.name}: #{e.message}"
            exit
        end
      end
  end

end
