
# Usage : ruby cc.rb <winner> <loser>

# Result - rankings file updated with new points

# Spec
# =================================================================================

# There will need to be a file containing the ranking list - ranking, name, and points.
# Equal points = equal ranking.  Then skip as discussed, 1,2,2,4  :)
# Output from the script should be an update ranking list in the file.  For bonus points, output it coded as a html table I can cut & paste onto the website ;)
# Input will be a list of name pairs, winner and loser.  I can give it in a file as a literal list of pairs if that makes life easier.
# The loser gets their current points value incremented by 1.
# If the winner is ranked equal or higher than the loser, they get their points incremented by 2.
#otherwise, the winners points are incremented by (Losers_Rank - Winners_Rank)+1.
# Re-sort the ranking list by points and update ranking position before processing the next winner/loser pair.  
# ==================================================================================

class Fencer
	attr_accessor :name, :points

	def initialize(name, points)
		@name   = name
		@points = points
	end

	def to_s 
		"#{name}  #{points}"
	end

	def to_html
		"<td> #{name} </td> <td> #{points} </td>"
	end

	def to_file
		"#{name},#{points}"
	end
end

class Ranking
	attr_accessor :rank, :fencer

	def initialize(rank, fencer)
		@rank   = rank
		@fencer = fencer
	end

	def to_s
		"#{rank}: #{fencer.to_s}"
	end

	def to_html
		"<tr> <td> #{rank} </td> #{fencer.to_html} </tr>"
	end
end

class Rankings
	attr_accessor :overall

	def initialize(ranks)
		ranks_sort = ranks.sort_by { |rr| -rr.points }

#puts "First ranks for Rankings:"
#p ranks_sort
		rankings = {}
		ranks_sort.each { |fp| 
			if (rankings[fp.points].nil?)
				rankings[fp.points] = [fp]
			else
				rankings[fp.points] = [*rankings[fp.points]] + [ fp]
			end
		}
#puts "First rankings:"
#p rankings
#puts "---------------"
#p rankings.sort
#puts "---------------"

#rankings = Hash[rankings.sort.reverse]
#p rankings
		@overall = []
		thisrank = 1
		rankings.keys.sort.reverse.each { |pts|
			farr = rankings[pts]
			farr.each { |fp|
				@overall << Ranking.new(thisrank, fp)
#				puts "#{thisrank} #{fp.name} #{fp.points}"
			}
			thisrank = thisrank + farr.size
		}
	end

	def calc_winner_points(fencer1, fencer2)
#puts "Start CWP"
#	p @overall
#p @overall.class
#p @overall[1]
#p @overall[1].class
#		winrank  = @overall.find {|rk| p rk; puts rk.class; puts rk.fencer.class; rk.fencer.name == fencer1 }.rank

		winrank  = @overall.find {|rk| rk.fencer.name == fencer1 }.rank
		loserank = @overall.find {|rk| rk.fencer.name == fencer2 }.rank
		
		if (winrank <= loserank)
			winpts = 2
		else
			winpts = (winrank - loserank) + 1
		end
		return winpts
	end

	def to_s
		@overall.join("\n")
	end

	def to_html
		header = "<table>\n<tr><th>Rank</th><th>Name</th><th>Points</th></tr>\n"
		cells = overall.map(&:to_html).join("\n")
		foot = "\n</table>"
		table = header + cells + foot
		table
	end
end

ranks = []
File.foreach("rankings") do |line|
	l2 = line.chomp.split(",")
	l2[1] = l2[1].to_i
	ranks = ranks + [ Fencer.new(*l2) ]
end

puts "Initial read of points:"
puts ranks

fencer1 = ARGV[0]
fencer2 = ARGV[1]

if (fencer1.nil? || fencer2.nil?)
	puts "Usage: ruby cc.rb <winner> <loser>"
	exit 0
end

if (! ranks.any? { |r| r.name == fencer1 })
	puts "Fencer1 not in ranking"
	ranks << Fencer.new(fencer1, 0)
end

if (! ranks.any? { |r| r.name == fencer2 }) 
	puts "Fencer2 not in ranking"
	ranks << Fencer.new(fencer2, 0)
end

initialranking = Rankings.new(ranks)

puts "\nInitial rankings :"
puts initialranking

puts "\nPoint update :"
winpts  = initialranking.calc_winner_points(fencer1, fencer2)
losepts = 1

puts "Winner #{fencer1}, gains #{winpts}"
puts "Loser #{fencer2}, gains #{losepts}"

ranks.find { |fp| fp.name == fencer1 }.points += winpts
ranks.find { |fp| fp.name == fencer2 }.points += losepts

puts "\nUpdated points:"
ranks = ranks.sort_by { |rr| -rr.points }
puts ranks

open('rankings.new', 'w') { |f|
f.puts ranks.map(&:to_file)
}

finalranking = Rankings.new(ranks)

# puts finalranking

puts finalranking.to_html

