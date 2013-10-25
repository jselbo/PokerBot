require 'net/http'

def connectDaServer(playerName, d)

	if d
		uri = URI("http://nolimitcodeem.com/sandbox/players/deal-phase-key")
	else
		uri = URI('http://nolimitcodeem.com/api/players/' + playerName)
	end

	
	return Net::HTTP.get(uri)
end


def post(playerName,hash_data, d)
	if d
		string = "http://nolimitcodeem.com/sandbox/players/deal-phase-key/action"
	else
		string = "http://nolimitcodeem.com/api/players/#{playerName}/action"
	end

	uri = URI(string)
	result = Net::HTTP.post_form(uri, hash_data)
end
