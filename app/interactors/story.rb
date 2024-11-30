class Story
  include Interactor

  before do
    @marvel_service = MarvelApiService.new
  end

  def call
    character_name = context.character_name
    character_data = @marvel_service.character(character_name)

    if character_data.nil?
      context.fail!(error: "No character found with name #{character_name}")
    else
      context.story = fetch_random_story(character_data)
    end
  end

  private

  def fetch_random_story(character_data)
    total_stories = character_data["stories"]["available"]

    if total_stories.zero?
      return { error: "No stories found for #{character_data['name']}" }
    end

    random_offset = rand(0..total_stories)
    stories = @marvel_service.stories(character_data["id"], limit: 1, offset: random_offset)

    format_story(stories.first) if stories&.any?
  end

  def format_story(story_data)
    {
      title: story_data["title"].presence || "Untitled",
      description: story_data["description"].presence || "No description available.",
      characters: format_characters(story_data["characters"]["items"])
    }
  end

  def format_characters(characters)
    characters.map do |character|
      character_details = @marvel_service.character_by_uri(character["resourceURI"])
      next unless character_details

      {
        name: character_details["name"],
        image: construct_image_url(character_details["thumbnail"], "portrait_xlarge")
      }
    end.compact
  end

  def construct_image_url(thumbnail, variant)
    "#{thumbnail['path']}/#{variant}.#{thumbnail['extension']}"
  end
end
