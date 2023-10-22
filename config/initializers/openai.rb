OpenAI.configure do |config|
  puts "Configuring OpenAI with token: #{ENV.fetch("OPENAI_ACCESS_TOKEN")}"
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
end
