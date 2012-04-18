# load Rails Console helpers like reload
if defined?(Rails) && Rails.env
  extend Rails::ConsoleMethods
  puts 'Rails Console Helpers loaded'
end
