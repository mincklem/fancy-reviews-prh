module WordCloud
	@count_limit
	@cloud_excludes
	@user_excludes
	class WordCount
		@@all_reviews_text = []
		@@reviews_count = 0
		attr_accessor :user_cloud_prefs
		
		def initialize(user_cloud_prefs)
			@user_cloud_prefs = user_cloud_prefs
		end

		def get_reviews_by_stars(isbn)
			@isbn = isbn
			#get user star selections
			@star_array = @user_cloud_prefs[0][:stars]
			#get user minimum term frequency
			@count_limit = @user_cloud_prefs[0][:count].to_i
			#get drop-in text if present

			#USE THIS ONE
			@drop_in_text= @user_cloud_prefs[0][:drop_in_text]

			
			#get user exclusion terms
			@user_excludes = @user_cloud_prefs[0][:cloud_excludes].downcase.split(' ')
			@user_excludes.collect{|x| x.strip}
			#If no drop-in text is provided
			if @drop_in_text.length == 0
				if @star_array.nil?
				reviews = Review.where(:isbn => @isbn)
				else
				@star_array.map!{ |element| element.gsub(/sb/, '') }
				reviews = Review.where(:star_rating => @star_array, :isbn => @isbn) 
				end
				#get review text from each and add to variable
				reviews.each do |review|
				@@all_reviews_text.push(review.review_text)
				end
				#convert to string, strip quotation marks
				@@reviews_count = @@all_reviews_text.length
				passing_text = @@all_reviews_text.to_s.tr('"','')
				count_words(passing_text)
			# If drop-in text IS provided
			else
				passing_text = @drop_in_text.to_s.tr('"','')
				count_words(passing_text)
			end
		end

		def count_words(passing_text)
			@@reviews_count
			#count the words
			text = passing_text.downcase.scan(/\s*("([^"]+)"|\w+)\s*/).map { |match| match[1].nil? ? match[0] : match[1] }
			#filter out common 'stopwords'
			f_text = text.delete_if{|x| $stop_words.split(" ").include?(x)}.join(' ')
			puts "CUT TEXT"
			puts f_text
			puts "CUT TEXT END"
			counts = Hash.new 0
			@total_term_count = 0
			f_text.split(" ").each do |word|
  				counts[word] += 1
  				@total_term_count+=1
			end
			sorted_counts = counts.sort_by(&:last)
			hash_counts = Hash[*sorted_counts.flatten]
			hash_counts.delete_if {|key, value| key.length <= 1 || value < @count_limit}
			#remove user exclusion words 
			@user_excludes.each do |word|
				hash_counts.delete_if {|key, value| key == word }
				puts "deleting #{word}"
			end
			puts "cleaned terms #{hash_counts}"
			@hash_counts_plus_avgs = Hash.new 0
			hash_counts.each do |key,value|
				#getting stars for reviews containing this top term
				@reviews_stars = []
				
				# TURN BACK ON
				# @reviews_containing_term = Review.where("review_text LIKE '%#{key}%'")
				# @reviews_containing_term.each do |review|
				# 	@reviews_stars.push(review.star_rating)
				# end
				# @term_star_average = @reviews_stars.inject{ |sum, el| sum + el }.to_f / @reviews_stars.size
				
				@hash_counts_plus_avgs[key] = [value, @term_star_average]
			end
			puts @hash_counts_plus_avgs	
			#remove 1 letter words (key.length) that appear less than a certain number of times (value) 
			@@all_reviews_text.clear
			
			#getting star rating average for reviews containing each top term
			@top_terms = [@hash_counts_plus_avgs, @@reviews_count, @total_term_count]
			@top_terms
		end

	end

	class StopWords
		$stop_words = 
			"a
			&#34;
			ve
			ll
			about
			above
			after
			re
			again
			against
			all
			am
			don
			an
			and
			any
			are
			aren't
			as
			at
			be
			because
			been
			before
			being
			below
			between
			like
			also
			much
			little
			really
			very
			great
			good
			both
			but
			by
			can
			can't
			cannot
			could
			couldn't
			did
			didn't
			do
			does
			doesn't
			doing
			don't
			down
			during
			each
			few
			for
			from
			further
			had
			hadn't
			has
			hasn't
			have
			haven't
			having
			he
			he'd
			he'll
			he's
			her
			here
			here's
			hers
			herself
			him
			himself
			his
			how
			how's
			i

			ing
			i'd
			i'll
			i'm
			i've
			if
			in
			into
			is
			isn't
			it
			it's
			its
			itself
			let's
			me
			more
			most
			mustn't
			my
			myself
			no
			nor
			not
			of
			off
			on
			once
			didn
			only
			or
			other
			ought
			our
			ours	ourselves
			out
			over
			own
			same
			shan't
			she
			she'd
			she'll
			she's
			should
			shouldn't
			so
			some
			such
			than
			that
			that's
			the
			their
			theirs
			them
			themselves
			then
			there
			there's
			these
			they
			they'd
			they'll
			they're
			they've
			this
			those
			through
			to
			too
			under
			until
			up
			very
			was
			wasn't
			we
			we'd
			we'll
			we're
			we've
			were
			weren't
			what
			what's
			when
			when's
			where
			where's
			which
			while
			who
			who's
			whom
			why
			why's
			with
			won't
			would
			wouldn't
			you
			you'd
			you'll
			you're
			you've
			your
			yours
			yourself
			yourselves
about
above
after
again
against
all
am
an
and
any
are
aren't
as
at
be
because
been
before
being
below
between
both
but
by
can't
cannot
could
couldn't
did
didn't
do
does
doesn't
doing
don't
down
during
each
few
for
from
further
had
hadn't
has
hasn't
have
haven't
having
he
he'd
he'll
he's
her
here
here's
hers
herself
him
himself
his
how
how's
i
i'd
i'll
i'm
i've
if
in
into
is
isn't
it
it's
its
itself
let's
me
more
most
mustn't
my
myself
no
nor
not
of
off
on
once
only
or
other
ought
our
ours 	
ourselves
out
over
own
same
shan't
she
she'd
she'll
she's
should
shouldn't
so
some
such
than
that
that's
the
their
theirs
them
themselves
then
there
there's
these
they
they'd
they'll
they're
they've
this
those
through
to
too
under
until
up
very
was
wasn't
we
we'd
we'll
we're
we've
were
weren't
what
what's
when
when's
where
where's
which
while
who
who's
whom
why
why's
with
won't
would
wouldn't
you
you'd
you'll
you're
you've
your
yours
yourself
yourselves
a
about
above
across
after
afterwards
again
against
all
almost
alone
along
already
also
although
always
am
among
amongst
amoungst
amount
an
and
another
any
anyhow
anyone
anything
anyway
anywhere
are
around
as
at
back
be
became
because
become
becomes
becoming
been
before
beforehand
behind
being
below
beside
besides
between
beyond
bill
both
bottom
but
by
call
can
cannot
cant
co
computer
con
could
couldnt
cry
de
describe
detail
do
done
down
due
during
each
eg
eight
either
eleven
else
elsewhere
empty
enough
etc
even
ever
every
everyone
everything
everywhere
except
few
fifteen
fify
fill
find
fire
first
five
for
former
formerly
forty
found
four
from
front
full
further
get
give
go
had
has
hasnt
have
he
hence
her
here
hereafter
hereby
herein
hereupon
hers
herse
him
himse
his
how
however
hundred
i
ie
if
in
inc
indeed
interest
into
is
it
its
itse
keep
last
latter
latterly
least
less
ltd
made
many
may
me
meanwhile
might
mill
mine
more
moreover
most
mostly
move
much
must
my
myse
name
namely
neither
never
nevertheless
next
nine
no
nobody
none
noone
nor
not
nothing
now
nowhere
of
off
often
on
once
one
only
onto
or
other
others
otherwise
our
ours
ourselves
out
over
own
part
per
perhaps
please
put
rather
re
same
see
seem
seemed
seeming
seems
serious
several
she
should
show
side
since
sincere
six
sixty
so
some
somehow
someone
something
sometime
sometimes
somewhere
still
such
system
take
ten
than
that
the
their
them
themselves
then
thence
there
thereafter
thereby
therefore
therein
thereupon
these
they
thick
thin
third
this
those
though
three
through
throughout
thru
thus
to
together
too
top
toward
towards
twelve
twenty
two
un
under
until
up
upon
us
very
via
was
we
well
were
what
whatever
when
whence
whenever
where
whereafter
whereas
whereby
wherein
whereupon
wherever
whether
which
while
whither
who
whoever
whole
whom
whose
why
will
with
within
without
would
yet
you
your
yours
yourself
yourselves
"
	end

end