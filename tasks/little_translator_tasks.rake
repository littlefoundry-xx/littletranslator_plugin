namespace :translations do
  desc "Sync translations with LittleTranslator"
  task :sync => :environment do
    reader = LittleTranslator::Reader.new
    response = LittleTranslator::Connection.sync!(reader.translations)
    response = Hash.from_xml(response.body)['response']
    if response['translations'].nil?
      puts "nothing to write!"
    else
      writer = LittleTranslator::Writer.new
      writer.translations = response['translations']
    end
  end

  desc "Show translation statistics"
  task :stats => :environment do
    reader = LittleTranslator::Reader.new
    num_locales = reader.translations.keys.size
    puts "locales: #{num_locales}"
  end
end
