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
