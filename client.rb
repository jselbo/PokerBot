require 'net/http'

def connectDaServer(playerName)

	uri = URI('http://nolimitcodeem.com/api/players/' + playerName)
	return Net::HTTP.get(uri)
end


