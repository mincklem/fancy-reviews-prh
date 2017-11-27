module ShelvesApi
		def self.call_shelves(isbn)
			#getting Goodreads work ID
			xml = RestClient.get "https://www.goodreads.com/book/show/#{isbn}?format=xml&key=LbfI8uwSm3Hd7X4Q1VoDsA"
	  		@json = JSON.load(Hash.from_xml(xml).to_json)
	  		@work_id = @json["GoodreadsResponse"]["book"]["work"]["id"]
	  		@shelves_all_pages = {}
	   		5.times do |num|
	  			import_api = "https://extraction.import.io/query/extractor/15359ba3-d4dd-450f-8ddc-a3925cbe5985?_apikey=793a9ecf8f8b4820bfbc41ef04962052ed3ee89485777d9173b742c41819f043b274cd1e574db22f8d43a02717c979504c91d8617c630cf0529c8306ca59beecea55014e913acdc8b38cf4ee5e526a66&url=https%3A%2F%2Fwww.goodreads.com%2Fwork%2Fshelves%2F#{@work_id}%3Fpage%3D#{num+1}"
	  			puts import_api
	  			@response = JSON.load(RestClient.get(import_api))
	  			puts @response
		  		if @response["errorType"] == "NotFoundException"
		  			puts "Book not found"
		  		elsif @response["extractorData"]["data"] == []
		  			puts "No More Reviews"
		  			@shelves_all_pages
		  		else
		  			@keys = []
					@values = []
			  		#if more than one shelf
			  		if @response["extractorData"]["data"][0]["group"].class == Array
			  			@response["extractorData"]["data"][0]["group"].each do |this_shelf|
	  						@keys.push(this_shelf["shelf_name"][0]["text"])
			  				@values.push(this_shelf["shelf_count"][0]["text"])
			  			end
			  		else
					#if only one shelf
						@keys.push(this_shelf@response["extractorData"]["data"]["group"]["shelf_name"])
						@values.push(this_shelf@response["extractorData"]["data"]["group"]["shelf_count"])		
		  			end

		  			@zipped = @keys.zip(@values)
					@h = Hash[@zipped]
					puts "===================@H=============================="
					puts @h
					@shelves_all_pages = @shelves_all_pages.merge(@h) 
					puts "===================@Merge=============================="
					puts @shelves_all_pages
		  		end
			end
			@shelves_all_pages
		end

end