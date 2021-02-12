require 'securerandom'
require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
    #TODO: reset secret with an ENV variable
    #see Using Sessions in http://sinatrarb.com/intro.html
  end

  get "/" do
    @recipes = Recipe.order(:created_at => :desc).limit(10)
    if logged_in?
      @user = current_user
    end
    #binding.pry
    erb :index
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by(:id => session[:user_id])
    end

    def assign_recipe_to_system(recipe)
      recipe_swap = User.find_by(:username => "RecipeSwap") || User.create(:username => "RecipeSwap", :password => SecureRandom.alphanumeric) #Do not need pw. Can work directly in DB.
      recipe.user = recipe_swap
      recipe.save
    end
  end

end