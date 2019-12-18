require 'telegram/bot'
require 'socket'
require 'geocoder'
require 'net/http'
require 'json'
require 'uri'
token = '763185869:AAFNSU1MAJNVDEbbaa5fCRk8raT4NOC9STU'
config.assets.initialize_on_precompile = false 
Telegram::Bot::Client.run(token) do |bot|
	bot.listen do |message|
		case message.text
		when '/chagan'
			bot.api.send_message(chat_id: message.chat.id, text: "Hi this is chanan here, find my commands")
		when '/send_location'
			url = 'https://jsonip.com/'
			uri = URI.parse(url)
			response = Net::HTTP.get_response(uri)
			if !response.nil?
				info_arr = JSON.parse(response.body)
				user_ip = info_arr['ip']
				lat_long_arr = Geocoder.coordinates(user_ip)
				if lat_long_arr.length > 0
					map_link = "https://maps.google.com/maps/?q="+[lat_long_arr[0],lat_long_arr[1]].join(",")
					bot.api.send_message(chat_id: message.chat.id, text: "you are here right now " + map_link)
				end
			else
				bot.api.send_message(chat_id: message.chat.id, text: "Sorry, Your location not found!")
			end
		end
	end
end