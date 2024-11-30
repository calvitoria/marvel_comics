class Story
  include Interactor

  def call
    marvel_service = MarvelApiService.new
    character_id = context.character_id

    total_stories = total_stories(character_id, marvel_service)

    if total_stories.positive?
      context.story = random_story(character_id, total_stories, marvel_service)
    else
      context.fail!(error: 'No stories found for the character')
    end
  end

  private

  def total_stories(character_id, marvel_service)
    marvel_service.character_stories(character_id)['total']
  end

  def random_story(character_id, stories_count, marvel_service)
    random_index = rand(0..stories_count)
    marvel_service.character_stories(character_id, offset: random_index)['results']&.first
  end
end
