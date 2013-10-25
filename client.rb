require 'net/http'


def connectDaServer(playerName)

	uri = URI('http://nolimitcodeem.com/api/players/' + playerName)
	return Net::HTTP.get(uri)
end


def post(playerName,hash_data)
	string = "http://nolimitcodeem.com/api/players/#{playerName}/action?"
	if hash_data["action_name"]
		string = string + 'action_name=' + hash_data["action_name"]
	end

	if hash_data["amount"]
		string = string + '&amount=' + hash_data["amount"].to_s
	end 
	uri = URI(string)
end
