class StoriesController < ApplicationController
  def index
    default_character = "storm"
    result = Story.call(character_name: default_character)

    if result.success?
      @story = result.story
    else
      @error = result.error
    end
  end
end
