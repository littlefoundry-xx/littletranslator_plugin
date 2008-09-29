path = File.dirname(__FILE__)
require File.join(path, 'signed_resource_client')
require File.join(path, 'i18n')
require File.join(path, 'little_translator/base')
require File.join(path, 'little_translator/reader')
require File.join(path, 'little_translator/writer')
require File.join(path, 'little_translator/connection')

module LittleTranslator
  def self.configure(&block)
    yield Base
  end
end

LittleTranslator::I18n.load_translations!
