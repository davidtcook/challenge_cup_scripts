
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
		header = "<table>\n<thead>\n<tr><th>Rank</th><th>Name</th><th>Points</th></tr>\n</thead><tbody>\n"
		cells = overall.map(&:to_html).join("\n")
		foot = "\n</tbody></table>"
		table = header + cells + foot
		table
	end
end

