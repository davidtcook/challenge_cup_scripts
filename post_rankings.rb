require 'rubypress'
require_relative 'ccup_lib'

ranks = []
File.foreach("rankings") do |line|
	l2 = line.chomp.split(",")
	l2[1] = l2[1].to_i
	ranks = ranks + [ Fencer.new(*l2) ]
end

today = Time.new.strftime("%d/%m/%Y")
content = "Rankings as at #{today}.\n"

finalranking = Rankings.new(ranks)

content = content + finalranking.to_html

p content

wp = Rubypress::Client.new(:host => "_", 
                           :username => "_", 
                           :password => "_")

p wp

z = wp.getPost({:post_id => 256})
p z
z = wp.editPost({:post_id => 256, :content => {:post_content => content } })
p z
z = wp.getPost({:post_id => 256})
p z
