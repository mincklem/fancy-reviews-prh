class ReviewsController < ApplicationController
	before_action :authenticate_user!
	respond_to :html, :xml, :json

  	include ReviewApi
  	include WordCloud
  	include ISBN
  	require 'date'
  	require 'lda-ruby'
  	require 'highscore'
  	require 'fast-stemmer'
  	require 'rake_text'
  	require 'graph-rank'
  	# require 'stanford-core-nlp'
  	require 'ruby_nlp/ngram'
  	require 'ruby_nlp/corpus'
	require 'ruby_nlp/corpus_files/brown'
	require 'matrix'
	require 'tf-idf-similarity'
	require 'cld'

def index
	  		@review = Review.new
	  		@goodreads_id = session[:isbn].to_s
	  		puts "SESSION ISBN #{@goodreads_id}"
	  		#
	  		@reviews = Review.where("(isbn LIKE '#{@goodreads_id}') AND (who_called LIKE '"+current_user.email+"') AND (review_text LIKE :query OR title LIKE :query)", 
	  		query: "%#{params[:search_reviews]}%")
		  	@img = session[:img]
	  		@title = session[:title]
	  		@author = session[:author]
	  		# @date = session[:date]
	  		@gr_reviews_count = session[:gr_reviews_count]
	  		#run recent titles function
	  		recentTitles
	  		
  	end

  	def recentTitles
  			 #count number of titles pulled this month, using recent titles timestamps
	  		@monthly_titles_pulled = 0
	  		@this_month = Date.today.strftime("%B")
  	#GET RECENT TITLES FOR ALL USERS
	  		@all_users = User.all 
	  		@all_users.each do |user|
	  			@this_month_count = 0
	  			#CHECKING ALL USER TITLE COUNTS FOR ADMIN
	  			if user.recent_titles
		  			user.recent_titles.each do |recent_title|
			  			@pulled_month = recent_title[4].split(" ")[0]
			  			if @pulled_month.to_s == @this_month.to_s
			  				@this_month_count+=1
			  			end
		  			end
	  			else 
	  				@this_month_count = 0
	  			end
	  			user.recent_titles << @this_month_count 
	  		end
	  		
	  		#GET RECENT TITLES FOR CURRENT USER
	  				  		@current_title_pulled_this_month_check = false
	  		@recent_titles = []
	  		current_user.recent_titles.each do |recent_title|
	  			#check if current title  was pulled this month 
		  		@pulled_month = recent_title[4].split(" ")[0]
		  		if @pulled_month.to_s == @this_month.to_s
			  		@monthly_titles_pulled+=1
			  		if recent_title[0] == session[:isbn]
	  				@current_title_pulled_this_month_check = true
	  				puts @current_title_pulled_this_month_check
	  			end
			  		@recent_titles.push(recent_title)
	  			end
	  		end

			# CHECK TITLE COUNT LIMIT FOR EACH USER
			@monthly_title_max_reached = false
			if current_user.email == "shared@prh.com" && @monthly_titles_pulled >= 3
				@monthly_title_max_reached = true
			end

			if current_user.email == "aslothus@prh.com" && @monthly_titles_pulled >= 200
				@monthly_title_max_reached = true
			end

			if current_user.email == "glevinson@prh.com" && @monthly_titles_pulled >= 50
				@monthly_title_max_reached = true
			end

			if current_user.email == "lkelly@prh.com" && @monthly_titles_pulled >= 30
				@monthly_title_max_reached = true
			end

			if current_user.email == "lcrisp@prh.com" && @monthly_titles_pulled >= 30
				@monthly_title_max_reached = true
			end

			if current_user.email == "dpassannante@prh.com" && @monthly_titles_pulled >= 30
				@monthly_title_max_reached = true
			end
	  		
	  		@monthly_titles_pulled
	  		@recent_titles
	  		#GET RECENTLY PULLED TITLES 
	  			
  		# end
  	end


  	def callReviews
  			#clearing database of reviews called by the current user
			if params[:clearisbn].to_i == 1
				puts "clearing now"
				Review.where(:isbn=>session[:isbn]).where(:who_called=>current_user.email).delete_all
			# check if book has been called recently
			else
				@goodreads_id = session[:isbn].to_s
				api_reviews = ReviewApi::CalledReviews.new

				# ========= GET REVIEWS BY BOOSHAKA CALLS ===========
				@@gr_check = false
				@@amz_check = false
				@gr_review_array = api_reviews.gr_reviews(@goodreads_id)
					if @gr_review_array.length > 1
						@@gr_check = true
					end
				@amz_review_array = api_reviews.amz_reviews(@goodreads_id)
					if @amz_review_array[0] != 1
						@@amz_check = true
					end
				@reviews_array = @gr_review_array.push(*@amz_review_array)
				@reviews_array = @reviews_array.uniq
				# ========= END BOOSHAKA CALL ===========
				
				# ========= GET REVIEWS BY JQUERY, FRONT END =========== 
				# 	platform = params[:call].to_i
				# # get Amazon Reviews
				# if platform == 1
				# 	@reviews_array = api_reviews.amz_reviews(@goodreads_id)
				# 	puts "AMAZON REVIEWS ARRAY #{@reviews_array}"
				# # check if Amazon reviews are ready
				# elsif platform == 1.1
				# 	params[:done=>true]
				# #get goodreads reviews
				# elsif platform == 2
				# 	@reviews_array = api_reviews.gr_reviews(@goodreads_id)
				# #check if amazon reviews are ready
				# elsif platform == 2.2
				# 	@reviews_array = api_reviews.gr_reviews(@goodreads_id)
						
				# end		

				#==========Alternate Goodreads call, calling via NOKOGIRI  ====
				# @gr_reviews_count = session[:gr_reviews_count]
				# puts "SESSION COUNT #{@gr_reviews_count}"
				# @gr_review_array = api_reviews.all_greads_alt_reviews(@goodreads_id, @gr_reviews_count)
				# 	if @gr_review_array.length > 1
				# 		puts "GOODREADS FINISHED"
				# 		@@amz_check = true
				# 		puts "making param #{@@gr_check}"
				# 	end
				# @reviews_array = @gr_review_array
				# # ========= END ALTERNATE CALL ===========

				# ========= COMBINE REVIEWS =========== 

				@reviews_array.each_with_index do |this|
						isbn = this[:isbn]
						rating = this[:rating]
						review_text = this[:review_text].gsub('&#34;', ' ')
						user = this[:user]
						likes = this[:likes]
						platform = this[:platform]
						title = session[:title].to_s		
						date = this[:date].to_s
						img = session[:img]
						author = session[:author]
						whocalled = current_user.email
					@added_review = Review.create(
							isbn: isbn, 
							title: title,
							author: author,
							date: date,
							review_text: review_text,
							platform: platform,
							star_rating: rating, 
							likes: likes,
							who_called: whocalled,
							img: img)
				end
			#UPDATE USER RECENT TITLES
			if current_user
				@title_pulled_this_month = false
				#check if the newly pulled title was pulled already this month
				current_user.recent_titles.each do |title|
					@pulled_month = title[4].split(" ")[0]
					@this_month = Date.today.strftime("%B")
					 if title[0] == @reviews_array[0][:isbn] && @pulled_month.to_s == @this_month.to_s
						@title_pulled_this_month = true
						puts @title_pulled_this_month
					end
				end
				#if the newly pulled title was pulled already this month, don't add
				if @title_pulled_this_month == true
					current_user.save
				else
					#if the newly pulled title wasn't pulled already this month, then add
					current_user.recent_titles << [@reviews_array[0][:isbn], session[:title].to_s, session[:author], session[:img], DateTime.now.strftime("%B %d, %Y"), @reviews_array.length]
					current_user.save
				end
				# if session ISBN is new, then add

			end
		# else
		# 	puts "ALREADY SEARCHED"
		end	
  	 	respond_to do |format|
			format.json { render json: @all_reviews_pass }
			format.js   { render json: @all_reviews_pass }
		end
  	end

  	def getReviews
  	  if @@amz_check == true
  	  		@@amz_check_array = [true]
  	  			respond_to do |format|
					format.json { render :json=> @@amz_check_array }
					format.js   { render :json=> @@amz_check_array }
				end
		end
  	
  end


    def show
  	@review = Review.find(params[:id])
  	end

  	def new
  	@review = Review.new
  	end

  	def create
		@goodreads_id = params[:choice]
		  #get isbn from session if it is blank
		  params[:choice] ||= session[:isbn]
		  #save isbn to session for future requests
		  session[:isbn] = params[:choice]
			session[:img] = params[:img]
			session[:title] = params[:title]
			session[:author] = params[:author]
			session[:gr_reviews_count] = params[:gr_reviews_count]
		redirect_to "/" 
  	end

  	def star_rating_filter
  		#get star filtered reviews text
	  	@user_cloud_prefs = [stars: params[:stars], count: params[:count], cloud_excludes: params[:cloud_excludes], drop_in_text: params[:drop_in_text]]
  		#pass to wordcounter
		new_count = WordCloud::WordCount.new(@user_cloud_prefs)
		@goodreads_id = session[:isbn]
		@top_terms = new_count.get_reviews_by_stars(@goodreads_id)
		# Add total reviews and top terms to array of length 2
		@@arr = []
		@arr2 = []
		#pass through total review count
		@@arr[0] = @top_terms[1]
		# pass through total terms count
		@@arr[1] = @top_terms[2]
		@top_terms[0].each do |key,value|
		  @arr2 << {:text => key, :weight => value[0], :term_star_avg => value[1]}
		end
		@@arr.push(@arr2)
		@@cloud_check = @@arr.to_json
		@@cloud_check = true
		#return to view 
		respond_to do |format|
		  format.json { render json: @@arr }
		  format.js   { render json: @@arr }
		end

  end

   def getCloud
  	  if
  	  		@@cloud_check == true
  	  			respond_to do |format|
					format.json { render :json=> @@arr }
					format.js   { render :json=> @@arr }
				end
		end
  	end

  
  def monkey
  	@goodreads_id = session[:isbn]
  	@reviews_monkey = Review.where("isbn LIKE '%#{@goodreads_id}%'")
  	@all_reviews_array = []
  	@reviews_monkey.each do |review|
		@text = review.review_text.downcase.gsub(/[^0-9a-z ]/i, '')
		@star = review.star_rating
		@all_reviews_array.push(@text)
	end
	@all_reviews_text = @all_reviews_array.to_sentence
	# EXCLUDE TITLE AND AUTHOR 
	# @exclude_array = [session[:author].split(" ").concat(session[:title].split(" "))]
	@exclude_array = params[:thematic_excludes].downcase.split(' ')

	# @exclude_array.collect{|x| x.strip}
	@exclude_array.each do |term|
		dwn_term = term.downcase.gsub(/[^a-z0-9\s]/i, '')
		@all_reviews_text = @all_reviews_text.gsub(dwn_term, " ")
	end
	
	@all_reviews_cleaned_array = @all_reviews_text.split(",")

# LDA EXPERIMENT
	# corpus = Lda::Corpus.new
	# # @all_reviews_cleaned_array.each do |review|
	# # corpus.add_document(Lda::TextDocument.new(corpus, review))
	# # end
	# corpus.add_document(Lda::TextDocument.new(corpus, @all_reviews_text))
	# lda = Lda::Lda.new(corpus)
	# lda.verbose = false
	# lda.num_topics = (3)
	# lda.em('random')
	# topics = lda.top_words(3)
	# puts topics
	# puts lda
	# @keywords_pass = topics
# END LDA EXPERIMENT 


# HIGHSCORE EXPERIMENT

	blacklist = Highscore::Blacklist.load $stop_words

	terms = Highscore::Content.new @all_reviews_text, blacklist
	terms.configure do
	  set :multiplier, 2
	  set :upper_case, 3
	  set :long_words, 2
	  set :long_words_threshold, 15
	  set :short_words_threshold, 3      # => default: 2
	  set :bonus_multiplier, 2           # => default: 3
	  set :vowels, 1                     # => default: 0 = not considered
	  set :consonants, 5                 # => default: 0 = not considered
	  set :ignore_case, true             # => default: false
	  set :word_pattern, /[\w]+[^\s0-9]/ # => default: /\w+/
	  set :stemming, false                # => default: false
	end

	@keywords_pass = []

	# get only the top 50 keywords
	terms.keywords.top(30).each do |keyword|
	  @keywords_pass.push([keyword.text, keyword.weight])   
	end

# END HIGHSCORE EXPERIMENT

#RAKETEXT EXPERIMENT
	# rake = RakeText.new
	# rake.analyse @all_reviews_text, RakeText.FOX, true
	# puts rake

#END RAKETEXT EXPERIMENT

# TEXTRANK Experiment
		# @keywords_pass = GraphRank::Keywords.new
		# @keywords_pass.stop_words = $stop_words
		# @keywords_pass.run(@all_reviews_text).inspect
		# @keywords_pass

# END RAKETEXT

#STANDFORD CORE EXPERIMENT
	# StanfordCoreNLP.use :english
	# StanfordCoreNLP.model_files = {}
	# StanfordCoreNLP.default_jars = [
	#   'joda-time.jar',
	#   'xom.jar',
	#   'stanford-corenlp-3.5.0.jar',
	#   'stanford-corenlp-3.5.0-models.jar',
	#   'jollyday.jar',
	#   'bridge.jar'
	# ]
	# text = @all_reviews_text
	# pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
	# text = StanfordCoreNLP::Annotation.new(text)
	# pipeline.annotate(text)
	# text.get(:sentences).each do |sentence|
	#   # Syntatical dependencies
	#   puts sentence.get(:basic_dependencies).to_s
	#   sentence.get(:tokens).each do |token|
	#     puts token.get(:original_text).to_s
	#     # Lemma (base form of the token)
	#     puts token.get(:lemma).to_s
	#     # Named entity tag
	#     puts token.get(:named_entity_tag).to_s
	#     # Coreference
	#     puts token.get(:coref_cluster_id).to_s
	#     # Also of interest: coref, coref_chain,
	#     # coref_cluster, coref_dest, coref_graph.
	#   end
	# end

#END STANDFORD CORE

#RUBY NLP NGRAM EXPERIMENT
# This is just so our relative file paths are relative to the right directory
# later on.


# This is just so our relative file paths are relative to the right directory
# later on.
# puts "Testing our n-grams implementation..."
# bigrams = Ngram.new(@all_reviews_text).bigrams
# trigrams = Ngram.new(@all_reviews_text).trigrams
# puts bigrams.inspect

# corpus = Corpus.new('app/assets/brown/*', BrownCorpusFile)

# capitals = ('A'..'Z')
# results = Hash.new(0)
# puts corpus.trigrams

# corpus.trigrams.each do |trigram|
#   if trigram.first == "of" && capitals.include?(trigram[1].chars.first)
#     result = [trigram[1]]

#     if capitals.include?(trigram[2].chars.first)
#       result << trigram[2]
#     end

#     results[result.join(' ')] += 1
#   end
# end

# puts results.sort_by { |k, v| v }.inspect

#RUBY NLP END

# Ruby Vector Space Model  TEST

	# document1 = TfIdfSimilarity::Document.new(@all_reviews_pass)
	# document2 = TfIdfSimilarity::Document.new(@all_reviews_pass)

	# corpus = [document1, document2]

	# # Create a document-term matrix using Term Frequency-Inverse Document Frequency function:

	# model = TfIdfSimilarity::TfIdfModel.new(corpus)
	# # Or, create a document-term matrix using the Okapi BM25 ranking function:

	# model = TfIdfSimilarity::BM25Model.new(corpus)
	# # Create a similarity matrix:

	# matrix = model.similarity_matrix
	# # Find the similarity of two documents in the matrix:

	# matrix[model.document_index(document1), model.document_index(document2)]
	# # Print the tf*idf values for terms in a document:

	# tfidf_by_term = {}
	# document1.terms.each do |term|
	#   tfidf_by_term[term] = model.tfidf(document1, term)
	# end
	# puts tfidf_by_term.sort_by{|_,tfidf| -tfidf}

	# # Tokenize a document yourself, for example by excluding stop words:

	# require 'unicode_utils'
	# text = "Lorem ipsum dolor sit amet..."
	# tokens = UnicodeUtils.each_word(text).to_a - ['and', 'the', 'to']
	# document1 = TfIdfSimilarity::Document.new(text, :tokens => tokens)

# Ruby Vector Space Model END

  	respond_to do |format|
		format.json { render json: @keywords_pass }
		format.js   { render json: @keywords_pass }
	end
  end

  def search 
  	#run recent titles function
  	recentTitles

		user_search = params[:search_books]
		@json = ISBN.find_isbn(user_search)
		@result_count = @json["GoodreadsResponse"]["search"]["results_end"].to_i
		@returned_books = @json["GoodreadsResponse"]["search"]["results"]["work"]
		# puts @returned_books
  end

  def welcome
  	redirect_to "/" 
  	@img = nil
  end

end

class ChartsController < ApplicationController
  def completed_tasks
    render json: Task.group_by_day(:completed_at).count
  end
end
