module LittleTranslator
  class Writer
    attr_accessor :translations

    def translations=(hash)
      @translations = hash
      write_translations
    end

    def write_translations
      self.translations.each do |locale, sections|
        locale_dir = File.join(Settings.locale_path, locale)
        File.send(:makedirs, locale_dir) unless File.exist?(locale_dir)
        sections.each do |section, translations|
          section_file = File.join(locale_dir, "#{section}.yml")
          File.open(section_file, 'w'){|file| file.write(translations.to_yaml) }
          logger.info(section_file.sub(%r{^#{Settings.locale_path}#{File::SEPARATOR}}, ''))
        end
      end
    end

    def logger
      Base.logger
    end

  end
end
