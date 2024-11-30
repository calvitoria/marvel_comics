class Story
  include Interactor

  before do
    @marvel_service = MarvelApiService.new
  end

  def call
    character_id = context.character_id
    total_stories = total_stories(character_id)

    if total_stories.positive?
      context.story = random_story(character_id, total_stories)
      context.characters = characters(context.story["id"])
    else
      context.fail!(error: "No stories found for the character")
    end
  end

  private

  def total_stories(character_id)
    @marvel_service.total_stories(character_id)["total"]
  end

  def random_story(character_id, stories_count)
    random_index = rand(0..stories_count)
    @marvel_service.story_by_id(character_id, offset: random_index)["results"]&.first
  end

  def characters(story_id)
    @marvel_service.story_characters(story_id)
  end
end
