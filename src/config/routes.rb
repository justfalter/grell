Rails.application.routes.draw do
  puts "Loading routes."
  mount API => '/'
end
