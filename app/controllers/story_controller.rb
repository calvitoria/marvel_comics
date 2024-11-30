class StoryController < ApplicationController
  def index
    marvel_service = MarvelApiService.new

    @character = marvel_service.character_details("storm")
    result = Story.call(character_id: @character.first['id'])
    @character_stories = result.stories
  end
end
