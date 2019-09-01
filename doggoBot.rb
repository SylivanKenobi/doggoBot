require 'telegram_bot'
require "open-uri"
require 'json'

token ='937227675:AAE_mW8rxW0sVlbqbGrTvGvfaHOKju1hx1k'

bot = TelegramBot.new(token: token)

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)
    message.reply do |reply|
    case command
    when /start/i
      reply.text = "Pawsome Dogs! Only for you!\n\nText \"breeds\" for all the puppers in our database.\nText your favourite breed name for extra cute pictures.\nText \"random\" for random doggo picture.\nText \"shibe\" for a cute picture of a shiba"
    when /breed/i
      result = ""
      resString = JSON.parse(URI.parse("https://dog.ceo/api/breeds/list/all").read)
      p resString["message"].map { |e| result += e[0] + "\n"}
      reply.text = "#{result}"
    when /random/i
      result = ""
      resString = JSON.parse(URI.parse("https://dog.ceo/api/breeds/image/random").read)
      result = resString["message"]
      reply.text = "#{result}"
    when /shibe/i
      result = ""
      resString = JSON.parse(URI.parse("http://shibe.online/api/shibes?count=1&urls=true&httpsUrls=true").read)
      result = resString
      reply.text = "#{result}"
    else
      result = ""
      begin
        resString = JSON.parse(URI.parse("https://dog.ceo/api/breed/#{message.text.downcase}/images/random").read)
      rescue StandardError => e
        reply.text = "We couldn't find anything for #{message.text} :("
        puts "sending #{reply.text.inspect} to @#{message.from.username}"
        reply.send_with(bot)
        break
      end
      reply.text = "#{resString['message']}"
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
