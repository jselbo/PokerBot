require "json"
require "pp"
load 'client.rb'

k = "6cd42ce7-e4e1-4c2a-8397-006dd27bc7b5"
debug = false

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
    
    suit_counts = Array.new(4)
    (0...4).each { |e| suit_counts[e] = 0 }
    cards.each do |e|
        second_digit = e[1]
        if second_digit == "C"
            suit_counts[0] += 1
        elsif second_digit == "S"
            suit_counts[1] += 1
        elsif second_digit == "D"
            suit_counts[2] += 1
        elsif second_digit == "H"
            suit_counts[3] += 1
        end
    end

    flush = false
    suit_counts.each do |e|
        if e == 5
            flush = true
        end
    end

    straight = false
    consec = 0
    count.each do |c|
        if c > 0
            consec += 1
            if consec == 5
                straight = true
                break
            end
        else
            consec = 0
        end
    end

    if flush and straight
        return 8
    end

    if three_of_kind > 0 && num_pairs > 0
        return 6
    end

    if flush
        return 5
    elsif straight
        return 4
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

def string_from_hand(hand)
    arr = ["High card",
        "One pair",
        "Two pair",
        "3 of a kind",
        "Straight",
        "Flush",
        "Full House",
        "Four of a kind",
        "Straight flush"]
    return arr[hand]
end

def get_decision(data)
	action = amount = nil

    phase = data["betting_phase"]
    puts "Phase: #{phase}"
    if phase == "deal"
        type = classify(data["hand"])
        if type == 1
            puts "-----we gots a pair on the ante-----"
            if data["current_bet"]+data["call_amount"] <= data["stack"]/10
                action = "raise"
                amount = data["stack"]/20
            else
                action = "call"
            end
        else
            if data["call_amount"] > data["stack"]/20
                action = "fold"
            else
                action = "call"
            end
        end
    else
        cards = data["hand"]
        table_cards = data["community_cards"]

        total_cards = cards + table_cards

        hand_type = classify(total_cards)
        hand_type_str = string_from_hand(hand_type)
        puts "HAND TYPE: #{hand_type_str}"
        if hand_type >= 6
            action = "raise"
            amount = data["stack"]
        elsif hand_type >= 3
            action = "raise"
            amount = data["stack"]/10
        elsif hand_type == 2
            if data["call_amount"]+data["current_bet"] > data["stack"]/8
                action = "fold"
            else
                action = "call"
            end
        elsif hand_type == 1
            if data["call_amount"]+data["current_bet"] <= data["stack"]/16
                action = "call"
            else
                action = "fold"
            end
        else
            if data["call_amount"] > 0
                action = "fold"
            else
                action = "call"
            end
        end
    end

    puts "Amount needed to call: #{data["call_amount"]}"
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
    response = connectDaServer(key, d)

    # Parse the response so you can use the data.
    turn_data = JSON.parse(response)

    # debugging
    # if d
    #     turn_data = { "your_turn"=>true, 
    #     	"initial_stack"=>500, 
    #     	"stack"=>450, 
    #     	"current_bet"=>50,
    #     	"call_amount"=>20,
    #     	"hand"=>["KS", "QD"],
    #     	"community_cards"=>["JS", "TC", "9H", "KD", "QS"], 
    #     	"betting_phase"=>"deal",
    #     	"players_at_table"=>{ },
    #     	"total_players_remaining"=>12,
    #     	"table_id"=>4,
    #     	"round_id"=>12
    #     }
    # end

    unless turn_data["lost_at"].nil?
    	date = turn_data["lost_at"]
    	puts "Our poker bot failed at #{date}... =("
    	puts "ending program"
    	abort("Noooooo")
    end

    if turn_data["your_turn"]
    	puts "Our turn!"
    	#puts "JSON dump:"
    	#puts "JSON:#{turn_data}"

        
    	decision = get_decision(turn_data)

    	post(key, decision, d)

        puts "\n"
    end

  end
end

dumb_poker_player(k, debug)

