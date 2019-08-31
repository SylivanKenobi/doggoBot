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
      reply.text = "Wanna doggos? Lemme fetch one for ya!"
    else
      result = ""
      resString = JSON.parse(URI.parse("https://dog.ceo/api/breeds/image/random").read)
      if resString.empty?
        reply.text = "Breed #{message.text} doesn't exist"
        puts "sending #{reply.text.inspect} to @#{message.from.username}"
        reply.send_with(bot)
        break
      end
        result += resString["message"] +  "\n"
      end
      reply.text = "#{result}"
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
