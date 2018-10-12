require 'graph-rank'
# Implement the PageRank algorithm
# for unsupervised sentence extraction.
class GraphRank::Sentences < GraphRank::TextRank

  begin
    require 'treat'
    include Treat::Core::DSL
  rescue
    puts "GraphRank::Sentences requires the treat " +
    "gem to work. Please run `gem install treat`."
  end

  # Stem stop words!
  def get_features
    @section = section(@text)
    .apply(:chunk,:segment,:tokenize)
    @features = @section.groups
  end
  
  # Build the co-occurence graph for an n-gram.
  def build_graph
    @features.each do |grp|
      wc = grp.word_count
      @features.each do |grp2|
        wc2 = grp2.word_count
        score = 0.0
        grp.each_word do |wrd|
          next if @stop_words.include?(wrd.to_s)
          grp2.each_word do |wrd2|
            score += 1 if wrd.stem == wrd2.stem
          end
        end
        score /= (Math.log(wc) + Math.log(wc2))
        @ranking.add(grp.id, grp2.id, score)
      end
    end
  end
  
  def run(text,n=4)
    rankings = super(text)
    rankings = rankings[0..n].map { |x|x[0] }
    @section.groups.select do |grp|
      rankings.include?(grp.id)
    end.map(&:to_s)
  end
  

end