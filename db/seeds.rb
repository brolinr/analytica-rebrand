DatabaseCleaner.clean_with(:truncation) if ENV.fetch('DB_CLEANER', 'OFF') == 'ON'

seed_files = Dir[Rails.root.join('db/seeds/*.rb')].sort
puts 'Seeds empty!' if seed_files.blank?

seed_files.each do |file|
  puts "Loading seed: #{file}"
  require file
end
