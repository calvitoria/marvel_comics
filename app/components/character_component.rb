# frozen_string_literal: true

class CharacterComponent < ViewComponent::Base
  def initialize(name:, image:)
    @name = name
    @image = image
  end
end
