module LittleTranslator
  class Connection < ActiveResource::Base
    self.site = 'http://localhost:3000/api/v1/'
    requires_signage

    def self.options_query
      hash = {}
      hash[:force] = 1 if ENV['FORCE']
      {:options => hash}.to_query
    end

    def self.locale
      @@locale ||= self.get("#{self.prefix}locale.xml")['message']
    end

    def self.sync!(translations)
      self.post("#{self.prefix}sync.xml?#{self.options_query}", translations[self.locale].to_xml(:root => 'translations'))
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
            error = Hash.from_xml(e.response.body)['response']
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
