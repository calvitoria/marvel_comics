class Story
  include Interactor
  
  def call
    marvel_service = MarvelApiService.new
    character_id = context.character_id
    total_number_of_stories = marvel_service.character_stories(character_id)['total']
    story = random_story(character_id, total_number_of_stories, marvel_service)
  end

  private

  def random_story(character_id, stories_count, marvel_service)
    random_story_index = rand(0..stories_count)

    marvel_service.character_stories(character_id, offset: random_story_index)
  end  
end
