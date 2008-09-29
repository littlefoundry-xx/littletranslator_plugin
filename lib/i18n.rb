module LittleTranslator
  class I18n
    def self.load_translations!
      Reader.new.translations.each do |locale, translations|
        ::I18n.backend.store_translations(locale, translations)
      end
    end

    module HelperMethods
      def t(key, args={})
        returning(h(key.to_sym.t)) do |str|
          args.each_pair do |k, v|
            str.gsub!("{{#{k}}}", v)
          end
        end
      end

      def pt(key, count, args={})
        returning(h(key.to_sym.pt(count))) do |str|
          args.each_pair do |k, v|
            str.gsub!("{{#{k}}}", v)
          end
        end
      end
    end

    module ControllerMethods
      def reload_locale_files
        logger.debug 'Reloading locale files'
        LittleTranslator::I18n.load_translations!
      end
    end

    module SymbolMethods
      def t(*args)
        ::I18n.translate(self, *args)
      end

      def pt(count, opts={})
        ::I18n.translate(self, {:count => count}.merge(opts))
      end
    end

    ActionView::Helpers.send(:include, HelperMethods)
    ActionController::Base.send(:include, ControllerMethods)
    Symbol.send(:include, SymbolMethods)

    if Rails.env.development?
      # reload locale files before each request in development
      ActionController::Base.send(:before_filter, :reload_locale_files)
    end

  end
end
