class PicturesController < ApplicationController
  def set_photo_from_url(url)
    self.image = URI.parse(url).open
  end
end