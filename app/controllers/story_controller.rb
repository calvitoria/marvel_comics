class StoryController < ApplicationController
  def index
    result = Story.call(character_name: "storm")

    @story = result.story
  end
end
