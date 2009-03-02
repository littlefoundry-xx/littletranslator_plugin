require File.join(File.dirname(__FILE__), 'signed_resource_client')
require File.join(File.dirname(__FILE__), 'little_translator', 'base')
require File.join(File.dirname(__FILE__), 'little_translator', 'reader')
require File.join(File.dirname(__FILE__), 'little_translator', 'writer')
require File.join(File.dirname(__FILE__), 'little_translator', 'connection')

module LittleTranslator
  def self.configure(&block)
    yield Base
  end

  def self.load_translations!
    Reader.new.translations.each do |locale, translations|
      ::I18n.backend.store_translations(locale, translations)
    end
  end
end

