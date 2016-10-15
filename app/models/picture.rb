require 'open-uri'
class Picture < ActiveRecord::Base
  belongs_to :movie
  has_attached_file :image, styles: {thumb: ["300x446>", :jpg]}
  validates_attachment :image,
                       content_type: {content_type: ["image/jpeg", "image/gif", "image/png"]}

  def set_photo_by_url(url)
    self.image = open(URI.parse(url), {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})
  end
end