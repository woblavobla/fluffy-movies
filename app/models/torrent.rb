class Torrent < ActiveRecord::Base
  belongs_to :movie
  has_attached_file :torrent_file

  validates_attachment_content_type :torrent_file, :content_type => "application/x-bittorrent"
end