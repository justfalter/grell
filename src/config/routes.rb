Rails.application.routes.draw do
  puts "Loading routes."
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/'
end
