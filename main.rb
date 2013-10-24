require "json"

def get_decision(data)
	action = amount = nil

	action = 

	response = { "action_name"=>action, "amount"=>amount }
end

def dumb_poker_player(key)
  # Infinite Loop
  while true 
  	# should sleep 1 second
    sleep 1

    # GET request.
    # Ask the server "What is going on?"
    response = connectDaServer(key)

    # Parse the response so you can use the data.
    #turn_data = JSON.parse(response.body)

    # debugging
    turn_data = { "your_turn"=>true, 
    	"initial_stack"=>500, 
    	"stack"=>450, 
    	"current_bet"=>50,
    	"call_amount"=>10,
    	"hand"=>["AS", "2C"],
    	"community_cards"=>["AS", "2C", "TH", "KD", "QS"], 
    	"betting_phase"=>"deal",
    	"players_at_table"=>{ },
    	"total_players_remaining"=>12,
    	"table_id"=>4,
    	"round_id"=>12
    }
    

    unless turn_data["lost_at"].nil?
    	date = turn_data["lost_at"]
    	puts "Our poker bot failed at #{date}... =("
    	puts "ending program"
    	abort("Noooooo")
    end

    if turn_data["your_turn"]
    	puts "Our turn!"
    	puts "JSON dump:"
    	puts "JSON:#{turn_data}"

    	puts "Making decision"
    	decision = get_decision(turn_data)

    	#take_action(key, decision)
    end

    # # Logic!!
    # # This logic is boring. But, yours should be more epic!
    # if turn_data["your_turn"]
    #   action = params = discards = nil

    #   # Is it a betting round, but not the river? Let's always call.
    #   if  turn_data["betting_phase"] == "deal" ||
    #       turn_data["betting_phase"] == "flop" ||
    #       turn_data["betting_phase"] == "turn"
    #     action = "call"
    #     params = nil
                  
    #   # Is it the river phase? Always bet 10 more.
    #   elsif turn_data["betting_phase"] == "river"
    #     action = "bet"
    #     params = 10
    #   end

    #   # Stores all your parameters in a single variable
    #   my_action = {:action_name => action, :amount => params}
    
    #   # POST a request to the server
    #   response = player_action(key, my_action)
    # end


  end
end

k = "HOLY BANANAS"

dumb_poker_player(k)

