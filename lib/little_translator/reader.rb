module LittleTranslator
  class Reader
    attr_accessor :translations

    def translations
      @translations ||= build_translations
    end

    def build_translations
      returning({}) do |data|
        read_locale_files do |locale, section, translations|
          data[locale] ||= {}
          raise "duplicate section #{section} for locale #{locale}" if data[locale][section]
          data[locale][section] = translations
        end
      end
    end

    def read_locale_files
      Dir[File.join(Settings.locale_path, '**', '*.yml')].each do |file|
        matches = file.match(%r{^#{Settings.locale_path}/([-_\w]+)/([-_\w]+)[.]yml$})
        next unless matches
        locale, section = matches[1], matches[2]
        data = YAML.load_file(file)
        yield [locale, section, data]
      end
    end

    def logger
      Base.logger
    end
    
  end
end
