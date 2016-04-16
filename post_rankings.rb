require 'rubypress'
require_relative 'ccup_lib'
require_relative 'wp_credentials'

ranks = []
File.foreach("rankings") do |line|
	l2 = line.chomp.split(",")
	l2[1] = l2[1].to_i
	ranks = ranks + [ Fencer.new(*l2) ]
end

today = Time.new.strftime("%d/%m/%Y")
content = "Rankings as at #{today}.\n"

finalranking = Rankings.new(ranks)

wins       = Hash.new(0)
losses     = Hash.new(0)
overall    = Hash.new(0)
scorelines = Hash.new(0)
refs       = Hash.new(0)
totalbouts = 0
boutsbyday = Hash.new(0)

ARGF.each do |line|
	fencer1, fencer2, score1, score2, ref, sbb = line.split
#	puts "f1:|#{fencer1}| f2:|#{fencer2}| s1:|#{score1}| s2:|#{score2}| r:|#{ref}|"
	wins[fencer1]   += 1; overall[fencer1] += 1
	losses[fencer2] += 1; overall[fencer2] += 1
	scorelines[score1.to_s + "-" + score2.to_s] += 1
	refs[ref] += 1
	totalbouts += 1
	boutsbyday[ARGF.filename] += 1
end

content += "<br>\nTotal bouts: #{ totalbouts }<br>\n"
bday = boutsbyday.max_by {|r| r[1]}
content += "Busiest day: #{ bday[1] } bouts on #{ bday[0][6..7] }/#{ bday[0][4..5] }/#{ bday[0][0..3] }"

content += "<br>\n"
content += finalranking.to_html

content += "<br>\nTop 5 by win ratio\n<br>"
content += "<table><thead><tr><th> Fencer </th> <th> Total </th> <th> Wins </th> <th> Losses </th> <th> Ratio </th></tr></thead><tbody>"
overall.keys.map {|fencer| [fencer, overall[fencer], wins[fencer], losses[fencer], 1.0*wins[fencer]/overall[fencer]] }.sort_by {|row| -row[4] }.first(5).each {|row| row[4] = "%4.2f" % row[4]; content += "<tr><td>" + row.join("</td> <td>") + "</td></tr>" }

content += "</tbody></table><br>\nTop 5 referees\n<br>"
content += "<table><thead><tr><th> Referee </th> <th> Total </th></tr> </thead><tbody>"
refs.keys.map{|ref| [ref, refs[ref]]}.sort_by {|row| -row[1]}.first(5).each {|row| content += "<tr><td>" + row.join("</td> <td>") + "</td></tr>" }

content += "</tbody></table>"

puts content

wp = Rubypress::Client.new(:host     => WP_HOST, 
                           :username => WP_USER, 
                           :password => WP_PASSWORD)

p wp

z = wp.getPost({:post_id  => 1354})
p z
z = wp.editPost({:post_id => 1354, :content => {:post_content => content } })
p z
z = wp.getPost({:post_id  => 1354})
p z
