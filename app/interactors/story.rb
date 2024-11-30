class Story
  include Interactor

  before do
    @marvel_service = MarvelApiService.new
  end

  def call
    character_name = context.character_name

    random_story = @marvel_service.random_story(character_name)
    context.story = random_story
  end
end
