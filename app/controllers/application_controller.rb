class ApplicationController < Sinatra::Base
  set(:default_content_type, "application/json")  #sets Json as the default return value for all our responses

  get '/games' do
   games= Game.all #we fetch all games from the db or
   #games = Game.all.order(:title) or games = Game.all.order(:title).limit(10)
   games.to_json #we convert it to Json and return it in this method.How it returns it is just like magic
   #NB:Here in the contoller is where all the operations on the data happen before returning the result.SO sorting happens here and any other operation on the data
  end

  get('/games/:id') do
    param = params[:id].to_i
    #Game.find(param).to_json  #converts the response to ajson string.This will be a single value returned.Only a game instance will come.

    #When we want to fetch the game and all its association, we need to pass options to the to_json method that passes to as_json method that determines how our object is serialized/changed to a json object
    #When including the associations, we input the instance methods that we passed to the macros when establishing the relationships
    #for reviews only, we pass include::reviews, for a deeper association level, the syntax changes a bit to include more levels
     
    #Game.find(param).to_json(include: :reviews)  #A game will come with all the associated reviews

     #Game.find(param).to_json(include:{reviews: {include: :user}}) #This will return a game, its reviews and the user who left the review.
    
     #NB//The argument passed to the association macro when creating the assocaiation is the one that is passed in here.
     #The fields returned here are all those that are in the model.If Less are needed, the only or except option is used

     ###A bit selective on the attributes returned- leaving out some attributes###
     Game.find(param).to_json(only: [:id,:title,:genre,:price],include: {reviews: {only: [:comment,:score],include: {user:{only:[:name]}}}})
     #The above line only highlights the indicated attributes
  end


  

end
