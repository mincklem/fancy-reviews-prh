require 'nokogiri'
require 'open-uri'
require 'thread'
require 'typhoeus'

module ReviewApi
	class CalledReviews
		def amz_reviews(isbn)
			@amz_reviews_array = [1]
			@isbn = isbn
			puts "CHECKING AMAZON ISBN #{@isbn}" 
			counter = 0
			5.times do |num|
				@api_url = "http://www.fanpagelist.com/analytics/reviews.php?api_key=91bee4c36&q=#{@isbn}&search_type=book_id&result_type=amazon&page=#{num+1}"
					puts @api_url
					response = JSON.load(RestClient.get(@api_url))
					puts "++++++++++++++++++" 
			  		break if response.length == 0
			  		puts response.length
			  		#retrying Amazon several times if results are empty
			  		# if response.length == 0
			  		# 	2.times do |num_num|
				  	# 		puts "retrying Amazon #{num_num+1} times"
				  	# 		@api_url = "http://www.fanpagelist.com/analytics/reviews.php?api_key=91bee4c36&q=#{@isbn}&search_type=book_id&result_type=amazon&page=#{num+1}"
							# puts @api_url
							# response = JSON.load(RestClient.get(@api_url))
							# puts "++++++++++++++++++" 
					  # 		puts response.length
					  # 		break if response.length > 0
			  		# 	end
		  			# puts "no more reviews"
		  	# 		@amz_reviews_array.shift
					# return @amz_reviews_array
			  # 		else
				  		response.each do |rev|
					    		mapped_review = {isbn: @isbn,
				    			rating: rev["rating"],
				    			review_text: rev["review_text"],
				    			user: rev["user"],
				    			date: rev["date"],
				    			platform: "Amazon"}
				    		@amz_reviews_array.push(mapped_review)
						end
					# end
			counter = counter+1
			puts "pulled Amazon #{counter}"
			end
		#Remove first element of array - the
		@amz_reviews_array.shift
		@amz_reviews_array
		end

		def gr_reviews(isbn)
			@gr_reviews_array = []
			@isbn = isbn
			counter = 0
			2.times do |num|
				@api_url = "http://www.fanpagelist.com/analytics/reviews.php?api_key=91bee4c36&q=#{@isbn}&search_type=book_id&result_type=goodreads&page=#{num+1}"
				response = JSON.load(RestClient.get(@api_url))
				puts @api_url
				puts "++++++++++++++++++" 
				puts response.length
				if response.length == 0
					puts "no more reviews"
			   		return @gr_reviews_array
			  	else
			  		response.each do |rev|
			  		   		mapped_review = {
			    			isbn: @isbn,
			    			rating: rev["rating"],
			    			review_text: rev["review_text"],
			    			user: rev["user"],
			    			date: rev["date"],
			    			platform: "Goodreads"}
			    		@gr_reviews_array.push(mapped_review)
					end
				end
			counter = counter+1
			puts "pulled Goodreads #{counter}"
			end
		@gr_reviews_array
		end

			#alternate Goodreads call
			##reviews only return first 300 characters, but each review sample has a link to the full text, a URL with a specific review ID, which we want.  This function extracts those IDs:
				
		def all_greads_alt_reviews(isbn, gr_reviews_count)
				puts "COUNT #{@gr_reviews_count}"
				@gr_reviews_count = gr_reviews_count
				@isbn = isbn
				@@all_reviews_text = []
				@@greads_count = 0
				@link_array = []
				@page_num = 0
				#arbitrary number 
				@@reviews_per_page = 15
			#========NOKOGIRI ID CALLS==================
			# @precall_link_list = []
			# for i in 1..20
			# 	@precall_link_list.push("https://www.goodreads.com/api/reviews_widget_iframe?did=0&format=html&isbn=#{@isbn}&links=660&page=#{i}")
			# end
			# @urls = @precall_link_list
			# @hydra = Typhoeus::Hydra.new
			# @successes = 0
			# @calls = 0
			# @responses = []
			# @response_links = []
			# @urls.each do |url|
			#     request = Typhoeus::Request.new(url, timeout: 150000)
			#     request.on_complete do |response|
			#         if response.success?
			#         	@calls+=1
			#         	@successes+=1
			#             @responses.push(response.body)
			#         else
			#             puts "Failed to get " + url
			#         end
			#     end
			# @hydra.queue(request)
			# end
			# @hydra.run 
			# if @calls == @urls.length
			# 	@responses.each do |response| 
			# 		@reviews = Nokogiri::HTML(response) { |c| c.noblanks }
		 #            @reviews_text = @reviews.css("div.gr_review_text")
			# 		@full_review_links = @reviews_text.css("link")
			# 		@full_review_links.each do |link|
			# 			@response_links.push(link)
			# 		end
			# 	end

			# end
			# @response_links.each do |link|
			# 	#isolating each review ID
			# 	@y = link.to_s.split("/")[5]
			# 	@id_ = @y[0..-3].to_i
			# 	@link_array.push(@id_)
			# end
			# 	puts @link_array.length
			# 	@link_array_deduped = @link_array.uniq.reverse
			# 	single_greads_review(@link_array_deduped.to_a, @isbn)


			# =========NOKOGIRI ID CALLS=========
			until @link_array.uniq.length >= 150 || @@reviews_per_page <= 3  do
				puts @link_array.length
				@link_list = []
				# 5.times do | page_num |
				@page_num+=1
				#nokogiri parses returned HTML for scraping - HTML
				@html_doc = Nokogiri::HTML(RestClient.get("https://www.goodreads.com/api/reviews_widget_iframe?did=0&format=html&isbn=#{@isbn}&links=660&num_reviews=1500&page=#{@page_num}")){ |c| c.noblanks }
				#check if run out of reviews
				@@reviews_per_page = @html_doc.css("div.gr_reviews_container").children.count
				#pull out each review block
				@reviews = @html_doc.css("div.gr_review_text")
				@full_review_links = @reviews.css("link")
				@full_review_links.each do |link|
					@link_list.push(link)
				end
				@link_list.each do |link|
					#isolating each review ID
					@x = link.to_s.split("/")[5]
					@id = @x[0..-3].to_i
					@link_array.push(@id)
				end
			end
				# if @@link_list.length == @@link_array.length
				@link_array_deduped = @link_array.uniq
				single_greads_review(@link_array_deduped.to_a, @isbn)
					# end

		end


		#Once we have the IDs, we scrape the full review for each ID, this using import.io, which converts any non-ajaxing page into a mini-API that we can call.
		def single_greads_review(link_array, isbn)
			@isbn = isbn
			@link_array = link_array.to_a
			puts "HERE #{@link_array}"
			@gr_reviews_raw_array = []
			@gr_reviews_array = []
			@url_array = []
			@link_array.each do | id |
				@url_array.push("https://api.import.io/store/connector/1f1928d6-9a29-44ec-a69b-10ef1b95035b/_query?input=webpage/url:https%3A%2F%2Fwww.goodreads.com%2Freview%2Fshow%2F#{id}&&_apikey=b9d0155921344d25ab7350773a60cc75f920175f7f9a88d6dbc7be1429fad209621626b014a52cee0e48ed62d68061516da9fd51e65138d62810534f1a1b4edb0c40f008c179ed3db1f5abc0a9b7be3b")
				# @url_array.push("https://www.goodreads.com/review/show/#{id}")
			end
			#split array into sets of 70, toggled to maximize speed
			@split_url_array = @url_array.each_slice(50).to_a
				#================= TYPHOEUS threading experiment===========
				@split_url_array.each do |array|
					urls = array
					hydra = Typhoeus::Hydra.new
					successes = 0
					calls = 0
					responses = []
					urls.each do |url|
						calls+=1
					    request = Typhoeus::Request.new(url, timeout: 150000)
					    request.on_complete do |response|
					        if response.success?
					            puts "Successfully requested " + url
					            successes += 1
					            responses.push(response.body)
					        else
					            puts "Failed to get " + url
					        end
					    end
					    hydra.queue(request)
					end
					hydra.run 
					puts responses.length
					if calls == urls.length
						responses.each do |that|
							 this = JSON.parse(that)
							#=======NOKOGIRI review text scrape===============
							# @html_review_doc = Nokogiri::HTML(this) { |c| c.noblanks }
							# @html_single_review_text = @html_review_doc.css("div.reviewText.mediumText.description").map {|node| node.text.strip }
							# @html_single_user = @html_review_doc.css("span.reviewer > a").map {|node| node.text.strip }
							# @html_single_review_date = @html_review_doc.css("div.right.dtreviewed.greyText.smallText > span:nth-child(1)").map {|node| node.text.strip }
							# @html_single_review_rating = @html_review_doc.css("div.rating > span.value-title").attr("title").value()
							# @html_single_review_likes = @html_review_doc.css("#review-like > span > span > span:nth-child(1) > a > span:nth-child(1)").map {|node| node.text.strip }.to_s.gsub(/[^0-9a-z ]/i, '')
							# if @html_single_review_likes != "0" || @html_single_review_likes != ""
							# 	@html_single_review_likes_integer = @html_single_review_likes.to_i
							# else
							# 	@html_single_review_likes_integer = 0
							# end	



				#=========NOKOGIRI SCRAPE - HTML VERSION =============
				
				# @html_review_doc = Nokogiri::HTML(open("https://www.goodreads.com/review/show/#{id}")) { |c| c.noblanks }
				# @html_single_review_text = @html_review_doc.css("div.reviewText.mediumText.description").map {|node| node.text.strip }
				# @html_single_user = @html_review_doc.css("span.reviewer > a").map {|node| node.text.strip }
				# @html_single_review_date = @html_review_doc.css("div.right.dtreviewed.greyText.smallText > span:nth-child(1)").map {|node| node.text.strip }
				# @html_single_review_rating = @html_review_doc.css("div.rating > span.value-title").attr("title").value()
				# @html_single_review_likes = @html_review_doc.css("#review-like > span > span > span:nth-child(1) > a > span:nth-child(1)").map {|node| node.text.strip }.to_s.gsub(/[^0-9a-z ]/i, '')
				# if @html_single_review_likes != "0" || @html_single_review_likes != ""
				# 	@html_single_review_likes_integer = @html_single_review_likes.to_i
				# else
				# 	@html_single_review_likes_integer = 0
				# end	

				# puts "LIKES #{@html_single_review_likes_integer}"
				#========IMPORT.IO SCRAPE  ==========
				# importio_greads_API ="https://api.import.io/store/connector/1f1928d6-9a29-44ec-a69b-10ef1b95035b/_query?input=webpage/url:https%3A%2F%2Fwww.goodreads.com%2Freview%2Fshow%2F#{id}&&_apikey=b9d0155921344d25ab7350773a60cc75f920175f7f9a88d6dbc7be1429fad209621626b014a52cee0e48ed62d68061516da9fd51e65138d62810534f1a1b4edb0c40f008c179ed3db1f5abc0a9b7be3b"
				# greads_raw_output = RestClient.get(importio_greads_API)
				# @greads_json_output = JSON.load(greads_raw_output)
				# puts "JSON OUTPUT #{@greads_json_output}"
					
					#=========NOKOGIRI SCRAPE REVIEW BUILD=========
						# @mapped_review = {
			   #  			isbn: @isbn,
			   #  			rating: @html_single_review_rating[0].gsub("\n", ""),
			   #  			review_text: @html_single_review_text[0].gsub(/[^0-9a-z ]/i, '').gsub('brbr', ''),
			   #  			user: @html_single_user[0].gsub("\n", ""),
			   #  			platform: "Goodreads",
			   #  			review_date: @html_single_review_date[0].gsub("\n", ""),
			   #  			likes: @html_single_review_likes_integer}
			   #  		@gr_reviews_array.push(@mapped_review)
						# end

					#===========import.io call review build============
						@rating = this["results"][0]["rating"]
						puts "RATING #{@rating}"
						@review_text = this["results"][0]["review_text"]
						@review_date =  this["results"][0]["date"]
						@mapped_review = {
			    			isbn: @isbn,
			    			rating: @rating,
			    			review_text: @review_text,
			    			platform: "Goodreads",
			    			review_date: @review_date}
			    		@gr_reviews_array.push(@mapped_review)
			    		end

					end
				end
		@gr_reviews_array
	end
end
end

