require 'configatron'

configatron.email.smtp do |smtp|
  smtp.address = 'smtp.example.com'
  smtp.port = 25
  smtp.username = 'user'
  smtp.domain = 'example.com'
end
