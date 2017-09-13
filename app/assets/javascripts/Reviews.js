$(document).ready(function(){
    console.log("HERE HERE");
    var isbn;
    var stars = [];
    var user_excludes = [];
    var count;
    var starAverage;
    var last_returned_terms;
    var called_this_cloud = false;
    var reviewTextStarArray = [];
    var reviewTextArray = [];
    var reviewTextString;
    var allStarRatings = [];
 
function callReviews() {
    $("#getGoodreads").click(function(){
        showSpinnerOverlay(this);
            $.ajax({
               type: "POST", 
               url: '/call',
               beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            });
    checkReviews();
    })
}

function checkReviews () {
    console.log("checking reviews");
        // just a control var...
        var gen = 1;
        // call the function repeatedly in 5 seconds of interval
        // this call returns an id that can be used to stop the calls
        var id = setInterval(function(){
            gen++;
            // checking if reviews are ready
            $.get('/get_reviews', function(response) {
                  console.log(response);
                  if (response[0] == true) {
                        clearInterval( id );
                        console.log("reviews Recieved");
                        location.reload()
                    }
            });
             // changing waiting text 
                console.log( "making an ajax request...(" + gen + ")" ); 
                if (gen == 5) {
                $("#amzNotify").text("Hang in there...")
                }
                else if (gen == 10) {
                $("#amzNotify").text("Enjoy a moment of zen...")
                }
                else if (gen == 15) {
                $("#amzNotify").text("...OK a few moments")
                }
        }, 5000 );
}

function callBNReviews() {
    $("#getBN").click(function(){
            $.ajax({
               type: "POST", 
               url: '/call',
               beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
               data: {"call": 1},
               success: function(response) {
                console.log(response);
                callGoodreadsReviews();
               }
            });
    })
}


function clearReviews() {
    $("#clearDB").click(function(){
            $.ajax({
               type: "POST", 
               url: '/call',
               beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
               data: {"clearisbn": 1},
               success: function(response) {
                console.log(response);
                location.reload()
               }
            });
    })
}


// function starPhraseButton(){
//         // get user star filter
//         $('button').click(function(){
//             if ($(this).hasClass("active")) {
//                 $(this).css("background-color", "#F7F5ED");
//                 stars.splice($.inArray($(this).attr('id'), stars), 1)
//             } else {
//             $(this).css("background-color", "rgb(230, 230, 230)");
//             stars.push($(this).attr('id'))
//             }
//         });
//     }

function cloudStarButtons(){
        // get user star filter
        $('.cloudstarbtn').click(function(){
            if ($(this).hasClass("active")) {
                $(this).css("background-color", "#F7F5ED");
                stars.splice($.inArray($(this).attr('id'), stars), 1);
                console.log(stars)
            } else {
            $(this).css("background-color", "rgb(230, 230, 230)");
            stars.push($(this).attr('id'));
            console.log(stars)
            }
        });
    }

function getSummaryPageReviews() {
    //pull review text
   $("#textual_analysis_tab").click(function() {
        $("#summarytable tr").each(function() {
            var reviewText = $(this).find(".reviewText").text().toLowerCase();
            reviewText = reviewText.replace(/[^a-zA-Z 0-9]+/g, '');
            var textStarRating = $(this).find(".starRating").text();
            if ($.isNumeric(parseInt(textStarRating))) {
                allStarRatings.push(parseInt(textStarRating));
                }
            reviewTextStarArray.push([reviewText, textStarRating]);
        });
        console.log(reviewTextStarArray);
        $.each(reviewTextStarArray, function() {
            reviewTextArray.push(this[0].replace(/[^a-zA-Z 0-9]+/g, ''))
        });
        reviewTextString = reviewTextArray.join(' ').replace(/[^a-zA-Z 0-9]+/g, '');
        starAverage = allStarRatings.reduce(function(sum, a) { return sum + a },0)/(allStarRatings.length||1);
   });  
}

function nlpNamedEntities(){
        //entity itentification
    $("#npl_entity").click(function() {
        var text = window.nlp(reviewTextString);
        var topics = text.topics().out('array');
        console.log(topics)
        // $.each(entity, function(){
        //     // $('#named_entity').append("<p>"+this.text.replace('“', '').replace('.', '').replace('"', '').replace(',', '')+"</p>")
        //     });
      });
}

function nlpNgramLengthClick(){
     $("#npl_ngram_length").click(function() {
            $(".ngram_table").remove();
            $(".fa-pulse").css("visibility", "visible");
            var f1 = showSpinnerOverlay(this);
             nlpNgramsLength(); // Alerts "123"
    });
}

function nlpNgramStarsClick(){
     $("#npl_ngram_stars").click(function() {
            $(".ngram_table").remove();
            $(".fa-pulse").css("visibility", "visible");
            showSpinnerOverlay(this);
            nlpNgramsStars();
     });
}

function nlpNgramsStars(){
        //================= NGRAMS BY LENGTH=====================
        var ngram_drop_in_text = $("#ngramDropIn").val().toLowerCase().replace(/[^a-zA-Z 0-9]+/g, '');
        var reviews_by_rating = [[],[],[],[],[]];
        var grams_by_rating = [[],[],[],[],[]]
        $("#ngramDropIn").val('');
        //if drop-in text exists, use that
        if (ngram_drop_in_text.length > 1) {
            var gram = window.nlp.ngram(ngram_drop_in_text, {min_count:3, max_size:6});
            //if not, use reviews
        } else {
        // GROUPING REVIEWS BY STAR RATING
            $.each(reviewTextStarArray, function(){
                if (this[1] == "1" || this[1] == "0") {
                    text = [this[0]];
                    reviews_by_rating[0].push(text)
                } else if (this[1] == "2") {
                    text = [this[0]];
                    reviews_by_rating[1].push(text)
                } else if (this[1] == "3") {
                    text = [this[0]];
                    reviews_by_rating[2].push(text)
                } else if (this[1] == "4") {
                    text = [this[0]];
                    reviews_by_rating[3].push(text)
                } else if (this[1] == "5") {
                    text = [this[0]];
                    reviews_by_rating[4].push(text)
                }
            });
        }
        console.log(reviews_by_rating);
        for (var i = 0; i < reviews_by_rating.length; i++) {
           var stringed_reviews = reviews_by_rating[i].join(" ");
           var grams = window.nlp.ngram(stringed_reviews, {min_count:3, max_size:6});
            //remove 1-gram terms
            // var cut_grams = grams.reverse().shift()
           grams_by_rating[i].push(grams)
        }
        console.log(grams_by_rating);
       
        //table terms
        var x = 5;
            $.each(grams_by_rating, function(){
                x = x-1;
                $("#ngrams_by_stars").append("<table class='table table-hover ngram_table' id='ngram_table"+x+"'><strong><caption>"+x+"-term Phrases</caption><thead><tr><th data-sort='string'>Phrase</th><th data-sort='float'>Freq</th><th data-sort='float'>Avg Stars</th><th data-sort='float'>Diff from Avg</th></strong></tr></thead></table>");
                $("#ngram_table"+x+"").stupidtable();
                $.each(this, function(){
                    var thisTermStarArray = [];
                    var phrase = this.word;
                    $.each(reviewTextStarArray, function(){
                        if (this[0].indexOf(phrase) >= 0) {
                             thisTermStarArray.push(this[1])
                        } 
                    });
                    //get average star rating
                    var sum = 0;
                    for( var i = 0; i < thisTermStarArray.length; i++ ){
                        sum += parseInt( thisTermStarArray[i], 10 ); //don't forget to add the base
                    }
                    var thisTermAvgStar = Math.round(sum/thisTermStarArray.length*Math.pow(10,2))/Math.pow(10,2);
                    var thisTermStarDifference = (thisTermAvgStar-starAverage).toFixed(2);
                    var color;
                    if (thisTermStarDifference > .2) {
                        color = "Green"
                    } else if ( thisTermStarDifference < -.2) {
                        color = "Red"
                    }
                    //append to table
                    $("#ngram_table"+x+"").append("<tr><td>"+this.word+"</td><td>"+this.count+"</td><td>"+thisTermAvgStar+"</td><td><span style='font-weight: bolder; color:"+color+"'>"+thisTermStarDifference+"</span></td></tr>");        
                });
                
            });
        hideSpinnerOverlay(this);
}

function nlpNgramsLength(){
        //================= NGRAMS BY LENGTH=====================
        var ngram_drop_in_text = $("#ngramDropIn").val().toLowerCase().replace(/[^a-zA-Z 0-9]+/g, '');
        console.log(ngram_drop_in_text);
        $("#ngramDropIn").val('');
        console.log(ngram_drop_in_text.length);
        //if drop-in text exists, use that
        if (ngram_drop_in_text.length > 1) {
            var gram = window.nlp.ngram(ngram_drop_in_text, {min_count:3, max_size:6});
            //if not, use reviews
        } else {
        // submitting text to nlp
        var gram = window.nlp.ngram(reviewTextString, {min_count:3, max_size:6});
        }
        //remove 1-gram terms
        var cut_gram = gram.splice(1).reverse();
        //table terms
        var x = 7;
            $.each(cut_gram, function(){
                x = x-1;
                $("#ngrams_by_length").append("<table class='table table-hover ngram_table' id='ngram_table"+x+"'><strong><caption>"+x+"-term Phrases</caption><thead><tr><th data-sort='string'>Phrase</th><th data-sort='float'>Freq</th><th data-sort='float'>Avg Stars</th><th data-sort='float'>Diff from Avg</th></strong></tr></thead></table>");
                $("#ngram_table"+x+"").stupidtable();
                $.each(this, function(){
                    var thisTermStarArray = [];
                    var phrase = this.word;
                    $.each(reviewTextStarArray, function(){
                        if (this[0].indexOf(phrase) >= 0) {
                             thisTermStarArray.push(this[1])
                        } 
                    });
                    //get average star rating
                    var sum = 0;
                    for( var i = 0; i < thisTermStarArray.length; i++ ){
                        sum += parseInt( thisTermStarArray[i], 10 ); //don't forget to add the base
                    }
                    var thisTermAvgStar = Math.round(sum/thisTermStarArray.length*Math.pow(10,2))/Math.pow(10,2);
                    var thisTermStarDifference = (thisTermAvgStar-starAverage).toFixed(2);
                    var color;
                    if (thisTermStarDifference > .2) {
                        color = "Green"
                    } else if ( thisTermStarDifference < -.2) {
                        color = "Red"
                    }
                    //append to table
                    $("#ngram_table"+x+"").append("<tr><td>"+this.word+"</td><td>"+this.count+"</td><td>"+thisTermAvgStar+"</td><td><span style='font-weight: bolder; color:"+color+"'>"+thisTermStarDifference+"</span></td></tr>");        
                });
                
            });
        hideSpinnerOverlay(this);
}

function showSpinnerOverlay(x){
        $(".fa-pulse").css("visibility", "visible");
        $(".summaryOverlay").css("visibility", "visible");
        $(".summaryOverlay").css("z-index", "2");
        console.log($(x).attr("id"));
          if ($(x).attr("id") == "getGoodreads") {
            $("#amzNotify").css("visibility", "visible")
        } else if ($(x).attr("id") == "starSubmit"){
            $(".apiProgress").css("visibility", "visible");
        }
}

function hideSpinnerOverlay(x){
            $(".fa-pulse").css("visibility", "hidden");
            $(".apiProgress").css("visibility", "hidden");
            $(".summaryOverlay").css("visibility", "hidden");
            $(".summaryOverlay").css("z-index", "-1");
          if ($(x).attr("id") == "getGoodreads") {
            $("#amzNotify").css("visibility", "hidden")
        } else if ($(x).attr("id") == "starSubmit"){
            $(".apiProgress").css("visibility", "hidden");
        }
}

// getting URL parameters from clicked cloud term
function getURLParameters(){
    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    };
    var cloud_term_search_parameter = getUrlParameter('search_reviews');
    // $("#search_reviews").attr("placeholder", cloud_term_search_parameter);
    $("#search_reviews").text(cloud_term_search_parameter);
    
}




function starSubmit(){
    $("#starSubmit").click(function(){
        ga('send', {
          hitType: 'event',
          eventCategory: 'Wordclouds',
          eventAction: 'Made Cloud',
          eventLabel: '1 Cloud'
        });
        console.log("star_Submit");
        console.log(stars);
        called_this_cloud = false;
        showSpinnerOverlay(this);
        //star checking
         checkCloudTerms();
        // get user minimum term frequency
        count = $("#count_limit").val();
        drop_in_text = $("#drop_in_text").val();
        $("#drop_in_text").val('');
        // get user exclusions
        cloud_excludes = $("#cloud_excludes").val();
            $.ajax({
           type: "POST", 
           url: '/stars',
           beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
           data: {"stars": stars, 
           "count": count, 
           "cloud_excludes":cloud_excludes,
            "drop_in_text":drop_in_text},
        });
    });

}

function checkCloudTerms() {
    console.log("checkingCloudcall");
        // just a control var...
        var gen = 1;
        // call the function repeatedly in 5 seconds of interval
        // this call returns an id that can be used to stop the calls
        var id = setInterval(function(){
            gen++;
            // checking if reviews are ready
            $.get('/checkCloud', function(response) {
                  if (response.length > 1 ) {
                        clearInterval( id );
                        console.log("reviews Recieved");
                        console.log(response);
                     hideSpinnerOverlay(this);
                    // prevent multiple clouds for same pull
                    if (called_this_cloud == false) {
                        called_this_cloud = true;
                        makeCloud(response);
                        }
                    }
            });
             // changing waiting text 
                console.log( "making an ajax request...(" + gen + ")" ); 
                if (gen == 5) {
                $("#cloudNotify").text("Hang in there...")
                }
                else if (gen == 10) {
                $("#cloudNotify").text("Enjoy a moment of zen...")
                }
                else if (gen == 15) {
                $("#cloudNotify").text("...OK a few moments")
                }
        }, 5000 );

}



var n = 0;
function makeCloud(terms) {
    console.log('making cloud');
    console.log(terms);
    var clean_terms = [];
    var chosenTitle = $("#chosenTitle").text();
    var chosenAuthor = $("#chosenAuthor").text();
    var titleTerms = chosenTitle.toLowerCase().split(" ");
    var authorTerms = chosenAuthor.toLowerCase().split(" ");
    var combinedTerms = titleTerms.concat(authorTerms);
        // if author and title are exempted 34 character 
        if ($('#authorCheck').is(":checked")) {
            $.each(terms[2], function(){
                    if ((this.text != 34) && ($.inArray(""+this.text+"", combinedTerms) == -1)) {
                        clean_terms.push(this)
                    };
                });
         // if author and title are NOT exempted - cutting out strange 34 character 
         } else {
            $.each(terms[2], function(){
                    if (this.text != 34) {
                        clean_terms.push(this)
                    };
                });
        };
    n = n+1;
    if (stars.length > 0) {
        var short_stars = []
            $.each(stars, function(){
                var star = this.replace("sb", " ");
                short_stars.push(star)
            });
        $(".wordCloudsBox").prepend("<div class='cloudBox' id='cloudBox"+n+"'><div id='cloudTitle' class='cloud_details'>"+chosenTitle+" by "+chosenAuthor+"</div><br><div class='cloud_details' id='cloudStats'> Reviews Sampled: "+terms[0]+" | Star Ratings: "+short_stars+" | Excluding Terms: "+user_excludes+"</div><div class='cloudx'>x</div><div class=cloudtablecontainer id='cloudtablecontainer"+n+"'><div class='cloud' id='cloud"+n+"'></div></div></div>");
      } else { 
     $(".wordCloudsBox").prepend("<div class='cloudBox' id='cloudBox"+n+"'><div id='cloudTitle' class='cloud_details'>"+chosenTitle+" by "+chosenAuthor+"</div><br><div class='cloud_details' id='cloudStats'> Reviews Sampled: "+terms[0]+" | Star Ratings: All | Excluding Terms: "+user_excludes+"</div><div class='cloudx'>x</div><div class=cloudtablecontainer id='cloudtablecontainer"+n+"'><div class='cloud' id='cloud"+n+"'></div></div></div>");
    }
    //table of wordcounts
    var term_array = [];
    var data_labels = [];
    var data_vals = [];
    var data_star_avgs = []
        $("#cloudtablecontainer"+n+"").append("<table class='table table-hover terms_table' id='term_table"+n+"'><thead><strong><th>Term</th><th>Frequency</th><th>% of Terms</th></strong></thead><tbody></tbody></table>")
    // $("#cloudtablecontainer"+n+"").append("<table class='table table-hover terms_table' id='term_table"+n+"'><thead><strong><th>Term</th><th>Frequency</th><th>% of Terms</th><th>Avg Star Rating</th></strong></thead><tbody></tbody></table>")
    $.each(clean_terms.reverse(), function(i, val){
        $.each(val, function(a, b){
            term_array.push(b);
            });
    });
    //convert terms hash to two arrays, values and labels 
    for(var i = 0; i < term_array.length; i += 3) {  // take every third element starting with first - get term
        data_labels.push(term_array[i]);
    }
    for(var i = 1; i < term_array.length; i += 3) {  // take every third element starting with 2nd - get frequency
        data_vals.push(term_array[i]);
    }
        for(var i = 2; i < term_array.length; i += 3) {  // take every third element starting with 3rd - get star rating avg
        data_star_avgs.push(term_array[i]);
    }
    //append labels and values to table 
    for(var i = 0; i < data_labels.length; i++) {  // take every second element
            var total = 0;
            var percent_of_terms = ((data_vals[i] / terms[1])*100).toFixed(2);
            if (data_star_avgs[i]) {
               $("#term_table"+n+"").append("<tr><td><a class='cloud_term_select' term="+data_labels[i]+">"+data_labels[i]+"</a></td><td>"+data_vals[i]+"</td><td>"+percent_of_terms+"%</td><td>"+data_star_avgs[i].toFixed(2)+"</td></tr>"); 
           } else {
            $("#term_table"+n+"").append("<tr><td><a class='cloud_term_select' term="+data_labels[i]+">"+data_labels[i]+"</a></td><td>"+data_vals[i]+"</td><td>"+percent_of_terms+"%</td><td></td></tr>");
            }
            // console.log((starAverage-data_star_avgs[i]).toFixed(3))
            // var integer  = parseInt(val);
            // total = total+integer;
            // console.log(total); 
            // $("#term_table"+n+"").text("Total Goodreads Shelves Sampled: "+total+"")
    };
 var short_clean_terms = clean_terms.splice(0,75);
 $("#cloud"+n+"").jQCloud(short_clean_terms, {
    height:450,
    width:650,
    autoResize:false,
    // shape: "rectangular",
    colors: ["#800026", "#bd0026", "#e31a1c", "#fc4e2a", "#fd8d3c", "#feb24c", "#fed976", "#ffeda0", "#ffffcc"],
       });
            $(".fa-pulse").css("visibility", "hidden");
        $("#cloudNotify").css("visibility", "hidden");
        $(".summaryOverlay").css("visibility", "hidden");
        $(".summaryOverlay").css("z-index", "-1");
    //storing last cloud's terms
        cloud_term_search();
    deleteCloud();
}

function cloud_term_search(){
    console.log("running");
    $(".cloud_term_select").click(function(){
        var clicked_term = $(this).attr('term');
        console.log(clicked_term);
        $("#search_reviews").val(""+clicked_term+"");
        $("input[name='utf8']").val("from_cloud");

       $('form#search_reviews_form').submit()
    })
}

function deleteCloud(){
    $(".cloudx").click(function(){
       $(this).parent().remove();
    
    })
}



//If on Search page, and MyLists or Recent Titles clicked, redirect to index//
function recentTitlesLists(){
    $("#recent_titles_tab, #my_lists_tab").click(function(){
        var url = window.location.href;
        if (url.indexOf("search") >= 0 || url.indexOf("welcome") >= 0) {
            window.location.replace("/")
            }
        else {}
    })
}


function shelvesCount(h){
    $("#shelvesCall").click(function(){
        // show loader
        $(".fa-pulse").css("visibility", "visible");
        $.ajax({
            type: "POST", 
            url: '/shelves',
           beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
           data: {"isbn":isbn}, 
           success: function(response) {
                if (response[0] == "false") {
                     $("#shelves_chart_box").css("display", "none");
                    $("#shelves").append("<div class='shelves_error'><h1>Sorry, Goodreads shelves counts are insufficient for this title, try another.</h1></div>");    
                } else  {
                    graphAllShelves(response[0]);
                    graphRollShelves(response[1]);
                    $(".shelves_table tbody").remove();
                    tableShelves(response)
                }
            }
        });        
    })
}

function storeISBN() {
    $("input[value='Get Reviews'").click(function(){
        isbn = $("input[name='choice']").attr("value");
    })
}

function quickDashLinks(){
    $( ".quickDashImage" ).on( "click", function() {
        var thisTarget = $(this).attr("value");
        console.log("#"+thisTarget+"");
        $("#"+thisTarget+"").trigger( "click" );
    });
}

function monkeyCall(){
    $("#themes_pull").click(function(){
      thematic_excludes =  $("#thematic_excludes").val();
    // show loader
    $(".fa-pulse").css("visibility", "visible");
    // get reviews text
    $.ajax({
        type: "POST", 
       url: '/monkey',
       beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
       data: {"thematic_excludes":thematic_excludes}, 
       success: function(response) {
        console.log(response);
        graphMonkey(response)
               }
            });
    });
}

function admin() {
    $("#adminLink").click(function(){
        $("#adminPanel").toggleClass("visible");
        console.log('hi')
    })
}

// function monkeyCall(response){
//      var reviewTextArray = [];
//     $("#themesTab").click(function(){
//        $("#summarytable tr").each(function() {
//             var reviewText = $(this).find(".reviewText").text().toLowerCase();
//             reviewText = reviewText.replace(/[^a-zA-Z 0-9]+/g, '');
//             reviewTextArray.push(reviewText);
//         });
//         $.ajax({
//         url : "https://api.monkeylearn.com/v2/extractors/ex_y7BPYzNG/extract/",
//         type : "POST",
//         headers: {
//             "Authorization": "token 21bac9c91a9c7a8b926d892b4f95c2743ab3d89b",
//         },
//         dataType: "jsonp",
//         contentType: "application/json; charset=utf-8",
//         data : JSON.stringify({
//           text_list: [""+reviewTextArray+""]
//         }),
//         success : function(result) {
//           graphMonkey(result);
//         },
//         error : function(e) {
//           alert('Error: ' + e);
//         }
//     });
//  })
// }


function activeTab(){   
    $('#myTab a').click(function (e) {
            e.preventDefault();
          $('this').tab('show')
    });
}

function showChoice(){
    $("input[value='Get Reviews']").click(function(){
        $(".chosenTitle").css("display", "block")
    })

}

function tableShelves(result){
    if ($.isEmptyObject(result[0])) {
        console.log("THAT'S UNDEFINED");
        $('#ngramerrorbox').css("visibility","visible")
    } else {
        $('#ngramerrorbox').css("visibility","hidden")
    var total = 0;
    $.each(result[1], function(i, val){
        $("#rolled_shelves_table").append("<tbody><td>"+i+"</td><td>"+val+"</td></tbody>");
    });
    $.each(result[0], function(i, val){
        $("#all_shelves_table").append("<tbody><td>"+i+"</td><td>"+val+"</td></tbody>");
        var integer  = parseInt(val);
        total = total+integer;
        $("#shelves_total_box").text("Total Goodreads Shelves Sampled: "+total+"")
    });
    }

}

function graphAllShelves(result){
    var data_labels = [];
    var data_vals = [];
    $.each(result, function(i, val){
        data_labels.push(i);
        data_vals.push(val);
    });
    var data = {
        labels: data_labels.slice(0,20),
        datasets: [
            {
                label: "My First dataset",
                fillColor: "#1B4171",
                strokeColor: "#1B4171",
                highlightFill: "rgba(220,220,220,0.75)",
                highlightStroke: "rgba(220,220,220,1)",
                data: data_vals.slice(0,20)
            }
        ]
    };
     var options = {
    //Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
    scaleBeginAtZero : true,

    //Boolean - Whether grid lines are shown across the chart
    scaleShowGridLines : true,

    //String - Colour of the grid lines
    scaleGridLineColor : "rgba(0,0,0,.05)",

    //Number - Width of the grid lines
    scaleGridLineWidth : 1,

    //Boolean - Whether to show horizontal lines (except X axis)
    scaleShowHorizontalLines: true,

    //Boolean - Whether to show vertical lines (except Y axis)
    scaleShowVerticalLines: true,

    //Boolean - If there is a stroke on each bar
    barShowStroke : true,

    //Number - Pixel width of the bar stroke
    barStrokeWidth : 2,

    //Number - Spacing between each of the X value sets
    barValueSpacing : 5,

    //Number - Spacing between data sets within X values
    barDatasetSpacing : 1,

    //String - A legend template
    legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].fillColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"

};
    // Get context with jQuery - using jQuery's .get() method.
    var ctx = $("#allShelvesChart").get(0).getContext("2d");
    // This will get the first returned node in the jQuery collection.
    var myNewChart = new Chart(ctx);
    // create chart
    if (data_vals.length > 1) {
          var myBarChart = new Chart(ctx).Bar(data, options);
     $(".fa-pulse").css("visibility", "hidden");
    }; 
}

function graphRollShelves(result) {
    var data_labels = [];
    var data_vals = [];
    $.each(result, function(i, val){
        data_labels.push(i);
        data_vals.push(val);
    });
    var data = {
        labels: data_labels,
        datasets: [
            {
                label: "My First dataset",
                fillColor: "#1B4171",
                strokeColor: "#1B4171",
                highlightFill: "rgba(220,220,220,0.75)",
                highlightStroke: "rgba(220,220,220,1)",
                data: data_vals
            }
        ]
    };
     var options = {
    //Boolean - Whether the scale should start at zero, or an order of magnitude down from the lowest value
    scaleBeginAtZero : true,

    //Boolean - Whether grid lines are shown across the chart
    scaleShowGridLines : true,

    //String - Colour of the grid lines
    scaleGridLineColor : "rgba(0,0,0,.05)",

    //Number - Width of the grid lines
    scaleGridLineWidth : 1,

    //Boolean - Whether to show horizontal lines (except X axis)
    scaleShowHorizontalLines: true,

    //Boolean - Whether to show vertical lines (except Y axis)
    scaleShowVerticalLines: true,

    //Boolean - If there is a stroke on each bar
    barShowStroke : true,

    //Number - Pixel width of the bar stroke
    barStrokeWidth : 2,

    //Number - Spacing between each of the X value sets
    barValueSpacing : 5,

    //Number - Spacing between data sets within X values
    barDatasetSpacing : 1,

    //String - A legend template
    legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].fillColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"

};
    // Get context with jQuery - using jQuery's .get() method.
    var ctx = $("#rollShelvesChart").get(0).getContext("2d");
    // This will get the first returned node in the jQuery collection.
    var myNewChart = new Chart(ctx);
    // create chart
    // if (data_vals.length > 1) {
          var myBarChart = new Chart(ctx).Bar(data, options);
     $(".fa-pulse").css("visibility", "hidden");
    // }; 
}

function graphMonkey(result) {
    // breakout results for graphing
    var keyword_labels = [];
    var keyword_weights = [];
    $.each(result, function(){
        keyword_labels.push(this[0]);
        keyword_weights.push(this[1]);
    });
    // convert string array to int array
    for(var i = 0; i < keyword_weights.length; i++)
        keyword_weights[i] = parseFloat(keyword_weights[i], 10);
    var data = {
        labels: keyword_labels,
        datasets: [
                {
                    label: "Goodreads Shelves",
                    fillColor: "rgba(220,220,220,0.2)",
                    strokeColor: "#1B4171",
                    pointColor: "rgba(220,220,220,1)",
                    pointStrokeColor: "#1B4171",
                    pointHighlightFill: "#1B4171",
                    pointHighlightStroke: "#1B4171",
                    data: keyword_weights
                },
            ]
        };
    var options = {
    //Boolean - Whether to show lines for each scale point
    scaleShowLine : true,

    //Boolean - Whether we show the angle lines out of the radar
    angleShowLineOut : true,

    //Boolean - Whether to show labels on the scale
    scaleShowLabels : false,

    // Boolean - Whether the scale should begin at zero
    scaleBeginAtZero : true,

    //String - Colour of the angle line
    angleLineColor : "rgba(0,0,0,.1)",

    //Number - Pixel width of the angle line
    angleLineWidth : 2,

    //String - Point label font declaration
    pointLabelFontFamily : "'Arial'",

    //String - Point label font weight
    pointLabelFontStyle : "normal",

    //Number - Point label font size in pixels
    pointLabelFontSize : 18,

    //String - Point label font colour
    pointLabelFontColor : "#666",

    //Boolean - Whether to show a dot for each point
    pointDot : true,

    //Number - Radius of each point dot in pixels
    pointDotRadius : 3,

    //Number - Pixel width of point dot stroke
    pointDotStrokeWidth : 1,

    //Number - amount extra to add to the radius to cater for hit detection outside the drawn point
    pointHitDetectionRadius : 20,

    //Boolean - Whether to show a stroke for datasets
    datasetStroke : true,

    //Number - Pixel width of dataset stroke
    datasetStrokeWidth : 3,

    //Boolean - Whether to fill the dataset with a colour
    datasetFill : true,

    //String - A legend template
    legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].strokeColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"
    }
    // Get context with jQuery - using jQuery's .get() method.
    var ctx = $("#keywordsChart").get(0).getContext("2d");
    // This will get the first returned node in the jQuery collection.
    var myNewChart = new Chart(ctx);
    // create chart
    var myRadarChart = new Chart(ctx).Radar(data, options);
     $(".fa-pulse").css("visibility", "hidden");
}

// function tableToCSV() {
//      d3.text("data.csv", function(data) {
//                 var parsedCSV = d3.csv.parseRows(data);

//                 var container = d3.select("body")
//                     .append("table")

//                     .selectAll("tr")
//                         .data(parsedCSV).enter()
//                         .append("tr")

//                     .selectAll("td")
//                         .data(function(d) { return d; }).enter()
//                         .append("td")
//                         .text(function(d) { return d; });
// })
// }

admin();
quickDashLinks();
deleteCloud();
cloud_term_search();
// starPhraseButton();
showChoice();
getURLParameters();
storeISBN();
shelvesCount();
monkeyCall();
activeTab();
cloudStarButtons();
starSubmit();
clearReviews();
recentTitlesLists();
// tableToCSV();
getSummaryPageReviews();
nlpNgramStarsClick();
nlpNgramLengthClick();
callReviews();

})
