#!/usr/local/bin/ruby
#
# Texas Hold'Em Poker Hand Evaluator
#
# A response to Ruby Quiz of the Week #24 - Texas Hold'Em [ruby-talk:134080]
#
# Evaluates a set of Texas Hold'Em Poker hands received on STDIN like so:
#   Kc 9s Ks Kd 9d 3c 6d
#   9c Ah Ks Kd 9d 3c 6d
#   Ac Qc Ks Kd 9d 3c
#   9h 5s
#   4d 2d Ks Kd 9d 3c 6d
#   7s Ts Ks Kd 9d
#
# And evaluates the hands and shows the winner, giving STDOUT like this:
#   Kc 9s Ks Kd 9d 3c 6d Full House (winner)
#   9c Ah Ks Kd 9d 3c 6d Two Pair
#   Ac Qc Ks Kd 9d 3c 
#   9h 5s 
#   4d 2d Ks Kd 9d 3c 6d Flush
#   7s Ts Ks Kd 9d 
#
# Author: Dave Burt <dave at burt.id.au>
#
# Created: 23 Mar 2005
#
# Last modified: 23 Mar 2005
#
# Fine print: Provided as is. Use at your own risk. Unauthorized copying is
#             not disallowed. Credit's appreciated if you use my code. I'd
#             appreciate seeing any modifications you make to it.
#

require 'cards'

module Poker
	include Cards

	Value::Ace.to_i = 14
	
	# each hand type has a name and a function taking a hand and returning it, 
	# sorted, or nil if the hand doesn't match this type.
	HandTypes = [
		['Royal Flush', proc {|hand| 
			if hand.find_all{|c|c.value >= 10}.map(:suit).frequencies(5).size >= 1
				Poker.find_straight(hand)
			end }],
		['Straight Flush', proc {|hand| 
			suit, count = *hand.map(:suit).frequencies(5)[0]
			if count && count >= 1
				if straight = Poker.find_straight(hand.find_all {|card| card.suit == suit })
					result = hand.dup
					result.delete_if {|card| straight.include?(card) }
					straight + result.sort_by_most_frequent(:value)
				end
			end }],
		['Four of a Kind', proc {|hand| 
			if hand.map(:value).frequencies(2).size >= 4
				hand.sort_by_most_frequent :value
			end }],
		['Full House', proc {|hand| 
			if hand.map(:value).frequencies(3).size >= 1 &&
			   hand.map(:value).frequencies(2).size >= 1
				hand.sort_by_most_frequent :value
			end }],
		['Flush', proc {|hand| 
			if hand.map(:suit).frequencies(5).size >= 1
				hand.sort_by_most_frequent :suit
			end }],
		['Straight', proc {|hand| 
			Poker.find_straight(hand) }],
		['Three of a Kind', proc {|hand| 
			if hand.map(:value).frequencies(3).size >= 1
				hand.sort_by_most_frequent :value
			end }],
		['Two Pair', proc {|hand| 
			if hand.map(:value).frequencies(2).size >= 2
				hand.sort_by_most_frequent :value
			end }],
		['Pair', proc {|hand| 
			if hand.map(:value).frequencies(2).size >= 1
				hand.sort_by_most_frequent :value
			end }],
		['High Card', proc {|hand| 
			hand.sort.reverse }]
	]
	
	#
	# Returns [n, "Hand type", ordered_cards]
	# The n at the front is bigger for better hands, so that
	# you can sort by hand_value.
	#
	def self.hand_value(cards, min_cards = 7)
		if cards.size >= min_cards
			HandTypes.each_with_index do |hand_type, index|
				hand_match = hand_type[1].call(cards)
				if hand_match
					return [
						HandTypes.size - index,
						hand_type[0],
						hand_match
					]
				end
			end
		end
		[0, '', cards.sort_by_most_frequent(:value)]
	end
	
	def self.find_straight(cards, min_length = 5)
		top = last = nil
		cards = cards.sort.reverse
		cards.each do |card|
			 if last.to_i - card.value.to_i <= 1
			 	top ||= last
			 else
			 	top = nil
			 end
			 last = card.value
			 
			 if top.to_i - card.value.to_i >= min_length - 1
			 	straight = []
			 	top.to_i.downto(card.value.to_i) do |i|
			 		straight << cards.delete(cards.find {|c| c.value.to_i == i })
			 	end
			 	return straight + cards
			 end
		end
		nil
	end
end

class Array
	include Cards::Deck
	
	def poker_value(min_cards = 7)
		Poker.hand_value(self, min_cards)
	end
	
	def to_s(long = nil)
		if long
			map {|obj| obj.to_s(long)}.join(', ')
		else
			join(' ')
		end
	end
	
	alias_method :old_map, :map
	def map(*method_call, &block)
		if method_call.empty?
			old_map &block
		else
			old_map {|element| element.send(*method_call, &block) }
		end
	end
	
	def sort_by_most_frequent(method)
		freq = map{|card| card.send(method) }.frequencies.map{|pair| pair.first }
		sort_by {|card| freq.index(card.send(method)) }
	end
	
	def frequencies(min = 1)
		uniq.map do |elem|
			[elem, find_all {|el| el == elem }.size]
		end.find_all do |pair|
			pair.last >= min
		end.sort_by do |pair|
			if pair.first.respond_to?(:<=>)
				[-pair.last, pair.first]
			else
				[-pair.last]
			end
		end
	end
end

class String
	def to_cards
		split.map {|s| Cards::Card[Cards::Value[s[0,1]], Cards::Suit[s[1,1]]] }
	end
end

if __FILE__ == $0
	include Poker
	
	input = STDIN
	
	if ARGV == ['--test']
		puts "test mode"
		require 'poker_test'
		input = Test::get_random_hands
	end
	
	hands = []
	
	# get hands from input and evaluate them
	input.each do |line|
		hands << line.to_cards.poker_value
	end
	
	# determine the winner
	winner = hands.inject([]) do |memo, hand|
		[memo, hand].max
	end
	
	# output each hand and its value
	hands.each do |hand|
		puts "#{hand[2]} #{hand[1]} #{'(winner)' if hand == winner}"
	end
end
