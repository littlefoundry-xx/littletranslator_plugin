module LittleTranslator
  class Settings
    def self.locale_path
      @@locale_path ||= File.join(RAILS_ROOT, 'config', 'locales')
    end
  end
end
