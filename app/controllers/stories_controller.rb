class StoriesController < ApplicationController
  def index
    character_name = params[:character_name].presence || "Storm"
    result = Story.call(character_name: character_name)

    if result.success?
      @story = result.story
      @favorite_character = result.favorite_character
    else
      @error = result.error
    end
  end
end
