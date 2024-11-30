class StoryController < ApplicationController
  def index
    Rails.cache.clear

    marvel_service = MarvelApiService.new
    @main_character = marvel_service.character_details("storm")

    result = Story.call(character_id: @main_character&.first["id"])

    @story = result.story
    @story_characters = result.characters
  end
end
