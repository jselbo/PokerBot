require "json"
require "pp"
load 'client.rb'

k = "aasdf"
debug = true

def classify(cards)
    count = Array.new(13)

    (0...13).each { |i| count[i] = 0 }

    pp cards
    cards.each do |e|
        first_digit = e[0]
        if first_digit.to_i.to_s == first_digit
            count[first_digit.to_i-1] += 1
        else
            if first_digit == "A"
                count[0] += 1
            elsif first_digit == "T"
                count[9] += 1
            elsif first_digit == "J"
                count[10] += 1
            elsif first_digit == "Q"
                count[11] += 1
            elsif first_digit == "K"
                count[12] += 1
            end
        end
    end

    num_pairs = 0
    three_of_kind = 0

    count.each do |e|
        if e == 2
            num_pairs += 1
        elsif e == 3
            three_of_kind += 1
        elsif e == 4
            return 7
        end
    end
    if three_of_kind > 0 && num_pairs > 0
        return 6
    end
    

    if three_of_kind > 0
        return 3
    elsif num_pairs > 1
        return 2
    elsif num_pairs == 1
        return 1
    end


    return 0
end

def get_decision(data)
	action = amount = nil

    phase = data["betting_phase"]
    puts "Phase: #{phase}"
    if phase == "deal"
        amt = data["call_amount"]
        action = "call"
    else
        cards = data["hand"]
        table_cards = data["community_cards"]

        total_cards = cards + table_cards

        hand_type = classify(total_cards)
        if hand_type > 1
            action = "raise"
            amount = 20
        elsif hand_type == 1

        else
            action = "fold"
        end
    end

    puts "action: #{action}"
    puts "amount: #{amount}"

	response = { "action_name"=>action, "amount"=>amount }
end

def dumb_poker_player(key, d)
  # Infinite Loop
  while true 
  	# should sleep 1 second
    sleep 1

    # GET request.
    # Ask the server "What is going on?"
    response = connectDaServer(key)

    # Parse the response so you can use the data.
    turn_data = JSON.parse(response)

    # debugging
    if d
        turn_data = { "your_turn"=>true, 
        	"initial_stack"=>500, 
        	"stack"=>450, 
        	"current_bet"=>50,
        	"call_amount"=>10,
        	"hand"=>["KS", "KH"],
        	"community_cards"=>["AS", "2C", "TH", "KD", "QS"], 
        	"betting_phase"=>"showdown",
        	"players_at_table"=>{ },
        	"total_players_remaining"=>12,
        	"table_id"=>4,
        	"round_id"=>12
        }
    end
    

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

    	puts "Making decision..."
    	decision = get_decision(turn_data)

    	post(key, decision)
    end

  end
end

dumb_poker_player(k, debug)

