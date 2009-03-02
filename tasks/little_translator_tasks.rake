namespace :translations do
  desc "Sync translations with LittleTranslator"
  task :sync => :environment do
    reader = LittleTranslator::Reader.new
    translations = LittleTranslator::Connection.sync!(reader.translations)
    if !translations || translations.empty?
      puts "no translations yet."
    else
      writer = LittleTranslator::Writer.new
      writer.translations = translations
    end
  end

  desc "Show translation statistics"
  task :stats => :environment do
    reader = LittleTranslator::Reader.new
    num_locales = reader.translations.keys.size
    puts "locales: #{num_locales}"
  end
end
