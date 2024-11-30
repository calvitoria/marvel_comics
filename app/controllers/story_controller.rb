class StoryController < ApplicationController
  def index
    marvel_service = MarvelApiService.new

    @character = marvel_service.character_details("storm")
  end
end
