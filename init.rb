require File.join(File.dirname(__FILE__), 'lib', 'little_translator')

if defined?(Rails) && Rails.env.development?
  # reload locale files before each request in development
  ActionController::Base.class_eval do
    def reload_locale_files
      logger.debug 'Reloading locale files'
      LittleTranslator.load_translations!
    end
    protected :reload_locale_files
    before_filter :reload_locale_files
  end
else
  # load 'em up here, and we won't do it ever again
  LittleTranslator.load_translations!
end

unless ::I18n.respond_to?(:available_locales)
  module ::I18n
    class << self
      def available_locales
        backend.available_locales
      end
    end
  
    module Backend
      class Simple
        def available_locales
          translations.keys
        end
      end
    end
  end
end  

require File.join(File.dirname(__FILE__), 'vendor', 'rails-i18n-translation-inheritance-helper', 'lib', 'i18n_translation_helper')
::I18n.send(:include, I18nTranslationHelper)
