
class Shelf < ActiveRecord::Base


	def self.get_shelves(isbn)
		@isbn = isbn
		puts "hitting shelves"
	  puts @isbn
	  @shelves_hash = ShelvesApi.call_shelves(@isbn)
		if @shelves_hash["status"] = false
        puts "bad Goodreads"
        @status = {:status => false}
        return @status
    else
    @shelf_names_array = []
        @new = Shelf.new
        @shelves_hash.each do |key, value|
           @shelf_names_array.push (key)
          if value != false
            @added_shelf = Shelf.create(
            isbn: @isbn.to_i,
            shelves: key,
            value: value.delete(",")) 
          end
        end
    end
  end



	def self.count_shelves(isbn)
		@isbn = isbn
		@all_shelves = Shelf.where(isbn: @isbn)
		@all_hash = {}
		@all_shelves.each do |this|
			if (this.shelves != "to-read") && (this.shelves !~ /\d/)  && (this.shelves != "to read")
           @shelf = this.shelves
            @val = this.value
            @all_hash[:"#{@shelf}"] = @val
      end
		end
		  puts @all_hash
		  #Category Roll-up Counts
      @music_count = 0
      @thriller_count = 0
      @evanovich_count = 0
      @philosophy_count = 0
      @race_count = 0
      @society_culture_count = 0
      @africa_count = 0
      @library_count = 0
      @crime_count = 0
  		@sci_count = 0
      @tudors_count = 0
  		@rom_count = 0
  		@mys_count = 0
  		@lit_count = 0
  		@fant_count = 0
      @high_fant_count = 0
      @epic_fant_count = 0
  		@wom_count = 0
  		@ser_count = 0
  		@hum_count = 0
  		@hor_count = 0
  		@fic_count = 0
      @nonfic_count = 0
  		@class_count = 0
  		@ser_count = 0
      @janeausten_count = 0
      @graphic_novel_count = 0
  		@ya_count = 0
  		@chick_count = 0
      @child_count = 0
      @hist_count = 0
      @bookclub_count = 0
      @european_countries_count = 0
      @culture_count = 0 
      @contemp_count = 0
      @spy_count = 0
      @membio_count = 0
      @psych_count = 0
      @selfhelp_count = 0
      @parenting_count = 0
      @beach_count = 0
      @retelling_count = 0
      @giveaway_count = 0
      @adult_count = 0
      @netgalley_count = 0
      @action_adventure_count = 0
      @marriage_count = 0 
      @dystop_count = 0
      @mag_count = 0
      @religion_count = 0
      @ebook_count = 0
      @audio_count = 0
      @susp_count = 0
      @cozy_count = 0
      @spiritual_count = 0
      @celebrity_count = 0
      @business_count = 0
      @paranormal_count = 0
      @science_count = 0
      @politics_count = 0
      @awards_count = 0
      @gay_count = 0
      @tech_count = 0
      @plantagenet_count = 0
      @royals_count = 0
      @leadership_count = 0
      @creativity_count = 0
      @popculture_count = 0
  		#Category Roll-up search functions
      @evanovich = Shelf.where(isbn: @isbn).where("shelves LIKE '%evanovich%'")
      @evanovich.each do |this|
        @evanovich_count = @evanovich_count + this.value.to_i
      end
  		#Science Fiction
  		@scifi = Shelf.where(isbn: @isbn).where("shelves LIKE '%scifi%' OR shelves LIKE '%sci-fi%' OR shelves LIKE '%sci/fi%' OR shelves LIKE '% scifi %'")
  		@scifi.each do |this|
  			@sci_count = @sci_count + this.value.to_i
      end
  		@music = Shelf.where(isbn: @isbn).where("shelves LIKE '%music%' OR shelves LIKE '%rock%' OR shelves LIKE '%ballad%' OR shelves LIKE '%song%'")
      @music.each do |this|
        @music_count = @music_count + this.value.to_i
      end
          @popculture = Shelf.where(isbn: @isbn).where("shelves LIKE '%pop culture%' OR shelves LIKE '%pop-culture%' OR shelves LIKE '%popular culture%'OR shelves LIKE '%pop_culture%'")
      @popculture.each do |this|
        @popculture_count = @popculture_count + this.value.to_i
      end
      @awards = Shelf.where(isbn: @isbn).where("shelves LIKE '%award%' OR shelves LIKE '%nationa book%' OR shelves LIKE '%national-book%' OR shelves LIKE '%pulitzer%' OR shelves LIKE '%booker%' OR shelves LIKE '%nationabl book%'")
      @awards.each do |this|
        @awards_count = @awards_count + this.value.to_i
      end
      #Society_Social_Issues
      @society_culture = Shelf.where(isbn: @isbn).where("shelves LIKE '%social%' OR shelves LIKE '%society%' OR shelves LIKE '%sociolog%' OR shelves LIKE '%cultur%'")
      @society_culture.each do |this|
        @society_culture_count = @society_culture_count + this.value.to_i
      end
      @politics = Shelf.where(isbn: @isbn).where("shelves LIKE '%politic%' OR shelves LIKE '%elect%' OR shelves LIKE '%vote%' OR shelves LIKE '%econom%' OR shelves LIKE '%poverty%' OR shelves LIKE '%inequality%' ")
      @politics.each do |this|
        @politics_count = @politics_count + this.value.to_i
      end
      #Science
        @science = Shelf.where(isbn: @isbn).where("shelves LIKE '%science%'")
      @science.each do |this|
        @science_count = @science_count + this.value.to_i
      end
     @celebrity = Shelf.where(isbn: @isbn).where("shelves LIKE '%celeb%' OR shelves LIKE '%hollywood%'")
      @celebrity.each do |this|
        @celebrity_count = @celebrity_count + this.value.to_i
      end
       @business = Shelf.where(isbn: @isbn).where("shelves LIKE '%business%' OR shelves LIKE '%bussiness%'")
      @business.each do |this|
        @business_count = @business_count + this.value.to_i
      end
        @dystop = Shelf.where(isbn: @isbn).where("shelves LIKE '%dystop%' OR shelves LIKE '%apoc%' OR shelves LIKE '%distopi%'")
      @dystop.each do |this|
        @dystop_count = @dystop_count + this.value.to_i
      end
   #retelling
  		@retelling = Shelf.where(isbn: @isbn).where("shelves LIKE '%retell%' OR shelves LIKE '%re-tell%'")
      @retelling.each do |this|
        @retelling_count = @retelling_count + this.value.to_i
      end
          #Romance 
      @rom = Shelf.where(isbn: @isbn).where("shelves LIKE '%romance%' OR shelves LIKE '%love%' OR shelves LIKE '%sex%'OR shelves LIKE '%hunk%' OR shelves LIKE '%swoon%' OR shelves LIKE '%hot%'OR shelves LIKE '%steam%'OR shelves LIKE '%erotic%' OR shelves LIKE '%pleasure%' OR shelves LIKE '%dreamy%'OR shelves LIKE '%dirty%' OR shelves LIKE '%heart%'")
  		@rom.each do |this|
  			@rom_count = @rom_count + this.value.to_i
  		end
  		  #Suspense
      @susp = Shelf.where(isbn: @isbn).where("shelves LIKE '%suspense%'")
      @susp.each do |this|
        @susp_count = @susp_count + this.value.to_i
      end
      #Mystery
  		@mys = Shelf.where(isbn: @isbn).where("shelves LIKE '%mystery%'")
  		@mys.each do |this|
  			@mys_count = @mys_count + this.value.to_i
  		end
       #Thriller 
      @thriller = Shelf.where(isbn: @isbn).where("shelves LIKE '%thrill%'")
      @thriller.each do |this|
        @thriller_count = @thriller_count + this.value.to_i
      end
        @tech = Shelf.where(isbn: @isbn).where("shelves LIKE '%tech%'")
      @tech.each do |this|
        @tech_count = @tech_count + this.value.to_i
      end
       @crime = Shelf.where(isbn: @isbn).where("shelves LIKE '%crime%' OR shelves LIKE '%detect%' OR shelves LIKE '%murder%'")
      @crime.each do |this|
        @crime_count = @crime_count + this.value.to_i
      end

  		#Women/Heroines
  		@wom = Shelf.where(isbn: @isbn).where("shelves LIKE '%woman%' OR shelves LIKE '%women%' OR shelves LIKE '%mother%' OR shelves LIKE '%daughter%' OR shelves LIKE '%mom%' OR shelves LIKE '%heroin%' OR shelves LIKE '%female%' OR shelves LIKE '%girl%' OR shelves LIKE '%sister%'")
  		@wom.each do |this|
  			@wom_count = @wom_count + this.value.to_i
  		end
      #Women/Heroines
      @race = Shelf.where(isbn: @isbn).where("shelves LIKE '%race%' OR shelves LIKE '%racial%' OR shelves LIKE '%asian-american%' OR shelves LIKE '%asia%' OR shelves LIKE '%asian american%' OR shelves LIKE '%chinese american%' OR shelves LIKE '%chinese-american%' OR shelves LIKE '%japanese-american%' OR shelves LIKE '%latin%' OR shelves LIKE '%hispan%' OR shelves LIKE '%blm%' OR shelves LIKE '%ethnic%' OR shelves LIKE '%racism%' OR shelves LIKE '%civil-right%' OR shelves LIKE '%civil right%' OR shelves LIKE '%african american%' OR shelves LIKE '%african-american%' OR shelves LIKE '%black%' OR shelves LIKE '%minority%' OR shelves LIKE '%divers%'")
      @race.each do |this|
        @race_count = @race_count + this.value.to_i
      end
  		#Literary
  		@lit = Shelf.where(isbn: @isbn).where("shelves LIKE '%liter%' OR shelves LIKE '%novel%'")
  		@lit.each do |this|
  			@lit_count = @lit_count + this.value.to_i
  		end
        #Ebook
      @ebook = Shelf.where(isbn: @isbn).where("shelves LIKE '%ebook%' OR shelves LIKE '%e-book%' OR shelves LIKE '%kindle%' OR shelves LIKE '%eread%' OR shelves LIKE '%e-read%' OR shelves LIKE '%ipad%'")
      @ebook.each do |this|
        @ebook_count = @ebook_count + this.value.to_i
      end
  		#Humor
  		@hum = Shelf.where(isbn: @isbn).where("shelves LIKE '%funny%' OR shelves LIKE '%lol%' OR shelves LIKE '%humor%'OR shelves LIKE '%humour%' OR shelves LIKE '%laugh%' OR shelves LIKE '%hilarious%'OR shelves LIKE '%comedy%'OR shelves LIKE '%comic%' OR shelves LIKE '%amusing%' OR shelves LIKE '%amuse%'OR shelves LIKE '%funn%'")
  		@hum.each do |this|
  			@hum_count = @hum_count + this.value.to_i
  		end
  		#Horror
  		@hor = Shelf.where(isbn: @isbn).where("shelves LIKE '%horror%' OR shelves LIKE '%ghost%' OR shelves LIKE '%scary%'OR shelves LIKE '%occult%' OR shelves LIKE '%gothic%' OR shelves LIKE '%macabre%'OR shelves LIKE '%terror%'OR shelves LIKE '%fear%' OR shelves LIKE '%spook%' OR shelves LIKE '%creep%'OR shelves LIKE '%eerie%'OR shelves LIKE '%creepy%' OR shelves LIKE '%fright%'OR shelves LIKE '%chilling%'OR shelves LIKE '%ghoul%'OR shelves LIKE '%demon%'OR shelves LIKE '%devil%'OR shelves LIKE '%terrif%'OR shelves LIKE '%haunt%'OR shelves LIKE '%dark%'OR shelves LIKE '%monster%'")
  		@hor.each do |this|
  			@hor_count = @hor_count + this.value.to_i
  		end
        #Library
      @library = Shelf.where(isbn: @isbn).where("shelves LIKE '%library%'")
      @library.each do |this|
        @library_count = @library_count + this.value.to_i
      end
  		#Non-Fiction
  		@nonfic = Shelf.where(isbn: @isbn).where("shelves LIKE '%non-fiction%' OR shelves LIKE '%nonfiction%' OR shelves LIKE '%non fiction%'")
  		@nonfic.each do |this|
  			@nonfic_count = @nonfic_count + this.value.to_i
  		end
      #Fiction
      @fic = Shelf.where(isbn: @isbn).where("shelves LIKE '%fiction%' AND shelves NOT LIKE '%non%'")
      @fic.each do |this|
        @fic_count = @fic_count + this.value.to_i
      end
  		#Classics
  		@class = Shelf.where(isbn: @isbn).where("shelves LIKE '%classic%'")
  		@class.each do |this|
  			@class_count = @class_count + this.value.to_i
  		end
  		#Series - CUSTOMIZED
  		@series = Shelf.where(isbn: @isbn).where("shelves LIKE '%series%' OR shelves LIKE '%revelations%' OR shelves LIKE '%riyria%'")
  		@series.each do |this|
  			@ser_count = @ser_count + this.value.to_i
  			
  		end
          #Paranormal
      @paranormal = Shelf.where(isbn: @isbn).where("shelves LIKE '%paranormal%' OR shelves LIKE '%angel%' OR shelves LIKE '%occult%' OR shelves LIKE '%vampir%' OR shelves LIKE '%vamps%' OR shelves LIKE '%supernatural%' OR shelves LIKE '%immortal%' OR shelves LIKE '%monster%'")
      @paranormal.each do |this|
        @paranormal_count = @paranormal_count + this.value.to_i 
      end
  		#Fantasy/Paranormal (General)
  		@fant = Shelf.where(isbn: @isbn).where("shelves LIKE '%fairy%' OR shelves LIKE '%magic%' OR shelves LIKE '%fantas%' OR shelves LIKE '%faerie%' OR shelves LIKE '%fairies%' OR shelves LIKE '%fae%' OR shelves LIKE '%elves%' OR shelves LIKE '% elf %' OR shelves LIKE '%fantas%'")
  		@fant.each do |this|
  			@fant_count = @fant_count + this.value.to_i	
      end
      #High Fantasy
      @high_fant = Shelf.where(isbn: @isbn).where("shelves LIKE 'high' OR shelves LIKE 'high-fantasy' OR shelves LIKE 'high fantasy' OR shelves LIKE 'high_fantasy' OR shelves LIKE 'fantasy_high' OR shelves LIKE 'fantasy-high' OR shelves LIKE 'fantasy high'")
      @high_fant.each do |this|
        @high_fant_count = @high_fant_count + this.value.to_i 
      end
      #Epic Fantasy
        @epic_fant = Shelf.where(isbn: @isbn).where("shelves LIKE 'epic' OR shelves LIKE 'epic-fantasy' OR shelves LIKE 'epic fantasy' OR shelves LIKE 'epic_fantasy' OR shelves LIKE 'fantasy_epic' OR shelves LIKE 'fantasy-epic' OR shelves LIKE 'fantasy epic'")
      @epic_fant.each do |this|
        @epic_fant_count = @epic_fant_count + this.value.to_i 
      end
      #MagicalRealism
      @mag = Shelf.where(isbn: @isbn).where("shelves LIKE '%magic%'")
      @mag.each do |this|
        @mag_count = @mag_count + this.value.to_i 
      end
    
  		#Young Adult 
  		@ya = Shelf.where(isbn: @isbn).where("shelves LIKE '%youngadult%' OR shelves LIKE '%young adult%' OR shelves LIKE '%young-adult%' OR shelves LIKE '%ya%'OR shelves LIKE '%young-adult%' OR shelves LIKE '%teen%'")
  		@ya.each do |this|
  			@ya_count = @ya_count + this.value.to_i
  		
  		end
  		#Chick-Lit
  		@chick = Shelf.where(isbn: @isbn).where("shelves LIKE '%chick%'")
  		@chick.each do |this|
  			@chick_count = @chick_count + this.value.to_i
  		
  		end
      @child = Shelf.where(isbn: @isbn).where("shelves LIKE '%child%' OR shelves LIKE '%kid%'")
      @child.each do |this|
        @child_count = @child_count + this.value.to_i
      
      end
       @hist = Shelf.where(isbn: @isbn).where("shelves LIKE '%hist%' OR shelves LIKE '%wwii%'")
      @hist.each do |this|
        @hist_count = @hist_count + this.value.to_i
      
      end
      @bookclub = Shelf.where(isbn: @isbn).where("shelves LIKE '%club%'OR shelves LIKE '%group%' OR shelves LIKE '%book-of-the-month' OR shelves LIKE '%botm'")
      @bookclub.each do |this|
        @bookclub_count = @bookclub_count + this.value.to_i
      
      end
      @european_countries = Shelf.where(isbn: @isbn).where("shelves LIKE '%brit%' OR shelves LIKE '%engl%' OR shelves LIKE '%scotland%' OR shelves LIKE '%scottish%' OR shelves LIKE '%euro%' OR shelves LIKE '%uk%' OR shelves LIKE '%italy%' OR shelves LIKE '%germany%' OR shelves LIKE '%ireland%'")
      @european_countries.each do |this|
        @european_countries_count = @european_countries_count + this.value.to_i
      
      end
         @contemp = Shelf.where(isbn: @isbn).where("shelves LIKE '%contemp%' OR shelves LIKE '%modern%'")
        @contemp.each do |this|
        @contemp_count = @contemp_count + this.value.to_i
      
      end
          @tudors = Shelf.where(isbn: @isbn).where("shelves LIKE '%tudor%'")
        @tudors.each do |this|
        @tudors_count = @tudors_count + this.value.to_i
      
      end
             @plantagenet = Shelf.where(isbn: @isbn).where("shelves LIKE '%plantag%'")
        @plantagenet.each do |this|
        @plantagenet_count = @plantagenet_count + this.value.to_i
      
      end
        @spy = Shelf.where(isbn: @isbn).where("shelves LIKE '% spy %' OR shelves LIKE '%espion%' OR shelves LIKE '%spies%'")
        @spy.each do |this|
        @spy_count = @spy_count + this.value.to_i
      
      end
       @membio = Shelf.where(isbn: @isbn).where("shelves LIKE '%memoir%' OR shelves LIKE '%biog%' OR shelves LIKE '% bio %'")
        @membio.each do |this|
        @membio_count = @membio_count + this.value.to_i
      
      end
        @psych = Shelf.where(isbn: @isbn).where("shelves LIKE '%psyc%' OR shelves LIKE '%brain%' OR shelves LIKE '%mind%' OR shelves LIKE '%think%' OR shelves LIKE '%thought%' OR shelves LIKE '%mental%' OR shelves LIKE '%aspberg%' OR shelves LIKE '%austism%'")
        @psych.each do |this|
        @psych_count = @psych_count + this.value.to_i
      
      end
       @selfhelp = Shelf.where(isbn: @isbn).where("shelves LIKE '%self help%' OR shelves LIKE '%self-help%' OR shelves LIKE '%self_help%' OR shelves LIKE '%self-improvement%' OR shelves LIKE '%self_improvement%' OR shelves LIKE '%self improvement%' OR shelves LIKE '%aspberg%' OR shelves LIKE '%austism%'")
        @selfhelp.each do |this|
        @selfhelp_count = @selfhelp_count + this.value.to_i
      
    end
        @parenting = Shelf.where(isbn: @isbn).where("shelves LIKE '%parent%'")
        @parenting.each do |this|
        @parenting_count = @parenting_count + this.value.to_i
      
    end
        @beach = Shelf.where(isbn: @isbn).where("shelves LIKE '%beach%' OR shelves LIKE '%summer%'")
        @beach.each do |this|
        @beach_count = @beach_count + this.value.to_i
      
    end
        @giveaway = Shelf.where(isbn: @isbn).where("shelves LIKE '%contest%' OR shelves LIKE '%giveaway%' OR shelves LIKE '%give away%'")
        @giveaway.each do |this|
        @giveaway_count = @giveaway_count + this.value.to_i
      
    end
      @adult = Shelf.where(isbn: @isbn).where("shelves LIKE '% adult %'")
        @adult.each do |this|
        @adult_count =  @adult_count + this.value.to_i
      
    end
       @netgalley = Shelf.where(isbn: @isbn).where("shelves LIKE '%netgalley%' OR shelves LIKE '% arc %'")
        @netgalley.each do |this|
        @netgalley_count =  @netgalley_count + this.value.to_i
    end

        @action_adventure = Shelf.where(isbn: @isbn).where("shelves LIKE '%adventur%' OR shelves LIKE '%quest%' OR shelves LIKE '%action%'")
        @action_adventure.each do |this|
        @action_adventure_count =  @action_adventure_count + this.value.to_i
    end
        @marriage = Shelf.where(isbn: @isbn).where("shelves LIKE '%marri%' OR shelves LIKE '%family%'")
        @marriage.each do |this|
        @marriage_count =  @marriage_count + this.value.to_i
    end
        @religion = Shelf.where(isbn: @isbn).where("shelves LIKE '%religi%' OR shelves LIKE '%scientology%' OR shelves LIKE '%christian%' OR shelves LIKE '%faith%' OR shelves LIKE '%god%'")
        @religion.each do |this|
        @religion_count =  @religion_count + this.value.to_i
    end
         @audio = Shelf.where(isbn: @isbn).where("shelves LIKE '%audio%' OR shelves LIKE '%audible%'")
        @audio.each do |this|
        @audio_count =  @audio_count + this.value.to_i
    end
        @cozy = Shelf.where(isbn: @isbn).where("shelves LIKE '%cozy%'")
        @cozy.each do |this|
        @cozy_count =  @cozy_count + this.value.to_i
    end
    #Janeausten
           @janeausten = Shelf.where(isbn: @isbn).where("shelves LIKE '%austen%'")
        @janeausten.each do |this|
        @janeausten_count =  @janeausten_count + this.value.to_i
    end
        @spiritual = Shelf.where(isbn: @isbn).where("shelves LIKE '%spiritual%'")
        @spiritual.each do |this|
        @spiritual_count =  @spiritual_count + this.value.to_i
    end
           @philosophy = Shelf.where(isbn: @isbn).where("shelves LIKE '%philosoph%'")
        @philosophy.each do |this|
        @philosophy_count =  @philosophy_count + this.value.to_i
    end
            @royals = Shelf.where(isbn: @isbn).where("shelves LIKE '%royal%' OR shelves LIKE '%monarch%'")
        @royals.each do |this|
        @royals_count =  @royals_count + this.value.to_i
    end
                @graphic_novel = Shelf.where(isbn: @isbn).where("shelves LIKE '%graphic%' OR shelves LIKE '%cartoon%' OR shelves LIKE '%comic%' OR shelves LIKE '%comix%'")
        @graphic_novel.each do |this|
        @graphic_novel_count =  @graphic_novel_count + this.value.to_i
    end
        @gay = Shelf.where(isbn: @isbn).where("shelves LIKE '%gay%' OR shelves LIKE '%homo%' OR shelves LIKE '%lgbt%' OR shelves LIKE '%lesbian%' OR shelves LIKE '%trans%' OR shelves LIKE '%queer%' OR shelves LIKE '%glbt%' OR shelves LIKE '%lgbtqia%' OR shelves LIKE '%lgbtqia%'")
        @gay.each do |this|
        @gay_count =  @gay_count + this.value.to_i
    end
              @creativity = Shelf.where(isbn: @isbn).where("shelves LIKE '%creat%'")
        @creativity.each do |this|
        @creativity_count =  @creativity_count + this.value.to_i
    end
                @leadership = Shelf.where(isbn: @isbn).where("shelves LIKE '%creat%'")
        @leadership.each do |this|
        @leadership_count =  @leadership_count + this.value.to_i
    end


  		@search_result = {:Science_Fiction => @sci_count, 
        :Music=> @music_count,
        :Pop_Culture=> @popculture_count,
        :Creativity => @creativity_count,
        :Leadership => @leadership_count,
        :Graphic_Novel => @graphic_novel_count, 
        :LGBT => @gay_count,
        :Plantaget=>@plantagenet_count,
        :Tudors=>@tudors_count,
        :Royals_Monarchy=>@royals_count,
        :European_Countries=>@european_countries_count,
        :Janet_Evanovich=>@evanovich_count,
        :Technology=>@tech_count,
        :Politics_Economics=>@politics_count,
        :Philosophy=>@philosophy_count,
        :Race_Diversity=>@race_count,
        :Society_Culture=>@society_culture_count,
  			:Romance_Sex => @rom_count,
        :Ebook => @ebook_count,
        :Thriller=>@thriller_count,
  			:Mystery=> @mys_count,
        :Paranormal => @paranormal_count,
  			:Fantasy =>@fant_count,
        :High_Fantasy => @high_fant_count,
        :Epic_Fantasy => @epic_fant_count,
        :Retelling=> @retelling_count,
  			:Dystopian_Apocalyptic=>@dystop_count,
        :Suspense=>@susp_count,
        :Crime=>@crime_count,
        :Women=>@wom_count,
  			:Literature_Literary=>@lit_count,
	  		:Humor=>@hum_count,
	  		:Horror=>@hor_count,
	  		:NonFiction=>@nonfic_count,
        :Fiction=>@fic_count,
	  		:Classic=>@class_count,
	  		:Series=>@ser_count,
	  		:Young_Adult=>@ya_count,
	  		:Chick_Lit=>@chick_count,
        :Childrens=>@child_count,
        :Historical=>@hist_count,
        :BookClub=>@bookclub_count,
        :Contemporary=>@contemp_count,
        :Spy_Espionage=>@spy_count,
        :Memoir_Biography=>@membio_count,
        :Psychology=>@psych_count,
        :Self_Help=>@selfhelp_count,
        :Parenting=>@parenting_count,
        :Library=>@library_count,
        :Summer_or_Beach=>@beach_count,
        :Giveaway_Contest=>@giveaway_count,
        :Adult=>@adult_count,
        :Netgalley_Arc=>@netgalley_count,
        :Africa=>@africa_count,
        :Action_Adventure=>@action_adventure_count,
        :Marriage_Family=>@marriage_count,
        :Book_Awards=>@awards_count,
        :Magic=>@mag_count,
        :Religion=>@religion_count,
        :Audio_Book=>@audio_count,
        :Cozy=>@cozy_count,
        :Spirituality=>@spiritual_count,
        :Jane_Austen=>@janeausten_count,
        :Celebrity=>@celebrity_count,
        :Business=>@business_count,
        :Science=>@science_count
  		}
  		puts @search_result
  		@returned_result = [@all_hash.sort_by {|_key, value| value}.reverse.to_h, @search_result.sort_by {|_key, value| value}.reverse.to_h.delete_if {|key, value| value == 0 }]
  		puts @returned_result
  		@returned_result
  	end
end
