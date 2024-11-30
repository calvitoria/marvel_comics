class StoryController < ApplicationController
  def index
    result = Story.call(character_name: "storm")

    if result.success?
      @story = result.story
    else
      @error = result.error
    end
  end
end
